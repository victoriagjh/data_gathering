//
//  ViewController.swift
//  data_gathering
//
//  Created by 권주희 on 06/06/2019.
//  Copyright © 2019 권주희. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate,AVAudioRecorderDelegate {

    @IBOutlet weak var textToSend: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var fileSend: UIButton!
    @IBOutlet weak var textSend: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    var recordSettings : [String: AnyObject] = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue as AnyObject,AVEncoderBitRateKey: 16 as AnyObject,AVNumberOfChannelsKey: 2 as AnyObject, AVSampleRateKey : 44100.0 as AnyObject]
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var soundFileURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playButton.isEnabled = false
        stopButton.isEnabled = false
        
        _ = dirPaths[0] as String
        
        let soundFilePath = dirPaths[0]
        soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            print("AudioSession Error")
        }
        do{
            try audioRecorder = AVAudioRecorder(url: soundFileURL! as URL, settings: recordSettings )
            audioRecorder?.prepareToRecord()
            
        } catch {
            print("AudioRecorder Error")
        }
    }
    
    @IBAction func record(_ sender: Any) {
        print("play")
        if audioRecorder?.isRecording == false {
            soundFileURL = NSURL(fileURLWithPath: makeSoundFileURL())
            do{
                try audioRecorder = AVAudioRecorder(url: soundFileURL! as URL, settings: recordSettings )
                audioRecorder?.prepareToRecord()
            } catch {
                print("AudioRecorder error")
            }
            recordButton.isEnabled = false
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
        
    }
    
    func makeSoundFileURL() -> String {
        let date:Date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy_MM_dd HH:MM:ss"
        formatter.timeZone = NSTimeZone(name:"UTC") as TimeZone?
        let dateString = formatter.string(from: date)
        
        let soundFilePath = dirPaths[0] + "/"+dateString+".wav"
        return soundFilePath
    }
    
    @IBAction func play(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            do{
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch{
                print("AudioPlayer error ")
            }
        }
    }
    @IBAction func stop(_ sender: Any) {
        print("stop")
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            print("Audio Recorder was not working")
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio")
    }
    
    @IBAction func train(_ sender: Any) {
    }
    
    @IBAction func test(_ sender: Any) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

