//
//  ViewController.swift
//  guess
//
//  Created by 林盈君 on 2020/8/30.
//  Copyright © 2020 林盈君. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var countLabel: UILabel!  //題數的Label
    @IBOutlet weak var scoreLabel: UILabel!  //分數的Label
    @IBOutlet weak var timeLabel: UILabel!  //計時的Label
    @IBOutlet weak var qViewImage: UIImageView!  //題目的ImageView
    @IBOutlet var choiceBTN: [UIButton]!  //選項的button
    
     //初始化
    var count = 1  //現在題數
    
    var score = 0  //計分
    var index = 0  //[Qnas]的索引
    var rightAnswer = ""  //正確答案的字串
    var choice = ""  //選項的字串
    var timer = Timer()  //計時器
    var time = 10  //倒數計時10秒
    
    var questionsInformation = [  //題目array
      QNA(question:"星巴克",choices:["露易莎","星巴克","西雅圖"],answer:"星巴克"),
      QNA(question:"家樂福",choices:["美聯社","家樂福","全聯"],answer:"家樂福"),
      QNA(question:"台新銀行",choices:["台新銀行","中國信託銀行","富邦銀行"],answer:"台新銀行"),
      QNA(question:"公視",choices:["台視","民視","公視"],answer:"公視"),
      QNA(question:"康是美",choices:["屈臣氏","康是美","美聯社"],answer:"康是美"),
      QNA(question:"全家",choices:["全家","7-11","萊爾富"],answer:"全家"),
      QNA(question:"達美樂",choices:["必勝客","拿坡里","達美樂"],answer:"達美樂"),
      QNA(question:"愛奇藝",choices:["Netflix","愛奇藝","楓林網"],answer:"愛奇藝"),
      QNA(question:"推特",choices:["Twitter","Telegram","WeChat"],answer:"Twitter"),
      QNA(question:"suzuki",choices:["subaru","suzuki","skoda"],answer:"suzuki")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        countLabel.text = String("\(count)")  //顯示題數
        scoreLabel.text = String("\(score)分")  //顯示計分
        timeLabel.text = String("\(time)")  //顯示倒數時間
        questionsInformation.shuffle()  //隨機出題
        playGame()  //執行指令playGame
    }
    
    
    //定義點選按鈕答題後會執行的function
    @IBAction func choicePressBTN(_ sender: UIButton) {
        time = 10
        timeLabel.text = String(time)
        count = count + 1
        countLabel.text = "\(count)"
        
        //讀取button上的標題
        if sender.currentTitle == rightAnswer {
            countLabel.text = "\(count)"
            score = score + 10
            scoreLabel.text = "\(score)分"
        } else {
            score = score - 30
            scoreLabel.text = "\(score)分"
        }
        
        
           //作答完10題或時間到將會出現警示視窗
           if (count == 11 || time == 0){
             count = 0
             countLabel.text = "\(count)"
             countDownFunc()
            
           } else {
             timeHelper() //處理計時器問題
             playGame()
        }
    }
    
    
    //定義時間處理的function，由於計時器重跑的設定會重複，所以獨立寫出一個函式來清空計時器
    func timeHelper(){
        timer.invalidate()
        time = 10
        timeLabel.text = String(time)
    }
    
    
    //定義計時器function
    func countDownTime(){
           timer = Timer.scheduledTimer(timeInterval: 1,
           target: self,
           selector: #selector(timerRun),
           userInfo: nil,
           repeats: true)
    }
       

    //定義計時器在倒數時要做什麼
    @objc func timerRun() {
        if time == 0 {
            countDownFunc()  //定義一個重新開始要做什麼的func
        }else{
            time -= 1
            timeLabel.text = String(time)
        }
    }
    
    
    //定義遊戲開始的function
    func playGame(){
        countDownTime() //原本是寫在 1.按選項按鈕就計時以及 2.時間到重新開始會再重新計時一次，但會變成兩個計時器再跑，所以時間會爆衝
        questionsInformation[index].choices.shuffle() //選項不固定
        qViewImage.image = UIImage(named:questionsInformation[index].question) //顯示題目圖片
        choice = "\(questionsInformation[index].choices)"  //丟入選項文字
        rightAnswer = "\(questionsInformation[index].answer)"  //丟入正確答案文字

        //設定button上的標題
        for i in 0...2{
            choiceBTN[i].setTitle(questionsInformation[index].choices[i], for: .normal)
        }
        index += 1
    }
    
    
    //定義把畫面上的東西重新設定的function
    func restart(){
        index = 0
        count = 1
        countLabel.text = "\(count)"
        score = 0
        scoreLabel.text = String(score)
        timeHelper()
        questionsInformation.shuffle()
        playGame()
        
    }
    
    
    //定義時間歸零後重新開始做事的function
    func countDownFunc(){
        timer.invalidate()  //計時器終止
        
        //產生警告視窗
        let alertController = UIAlertController(title:"恭喜你完成測驗囉！", message: "獲得\(score)分", preferredStyle: .alert)
        
        let okBTN = UIAlertAction(title: "簡單啦", style: .default, handler: nil)   //設定視窗按鈕「簡單啦」
        alertController.addAction(okBTN)  //彈出視窗上加上按鈕
               
        let replayBTN = UIAlertAction(title: "再玩一次", style: .default){(_)in
            self.restart()   //點選按鈕後將會執行的動作
        }
        alertController.addAction(replayBTN)  //彈出視窗上加上按鈕
        present(alertController, animated: true, completion: nil)  //使用 present來顯示視窗畫面
    }
    
    
}




