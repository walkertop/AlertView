//
//  AlertView.swift
//  SohuAuto
//
//  Created by 郭彬 on 16/10/2.
//  Copyright © 2016年 WuJason. All rights reserved.
//

import UIKit
import SnapKit

private struct AlertViewConstant {
    static let animationDuration = 0.3
    static let titleLabelFontSize: CGFloat = 16.0
    static let messageLabelFontSize: CGFloat = 14.0
    static let actionBtnFontSize: CGFloat = 16.0

}

class AlertView: UIView {
    
    //MARK: - Properties
    private var verticalInterval: CGFloat = 25.0
    
    private var title: String
    private var message: String?
    var actionArray = [AlertAction]()
    var dict: [UIButton: AlertAction] = [:]
    var isHasCancel: Bool = true

    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var customAlertView:UIView!
    private var verticalLine: UIView!
    private var horizontalLine: UIView!
    private var buttonContainerView: UIView!        //底部按钮的容器 view
    
    init(title: String,message: String?) {
        self.title = title
        self.message = message
        super.init(frame:UIScreen.main.bounds)
        setupSubViews()
    }
    
    func setupSubViews() {
        
        layoutCustomAlertView()
        layoutButtonContainerView()
        
        if let message = self.message {//有 message
            layoutTitleLabel(title: title)
            layoutMessageLabel(message: message)
            
        } else {//没有 message
            layoutTitleLabelWithoutMessage(title: title)
        }
        layouthorizontalLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layouthorizontalLine() {
        horizontalLine = UIView()
        horizontalLine.backgroundColor  = UIColor.g4()
        self.addSubview(horizontalLine)

        horizontalLine.snp.makeConstraints { (make) in
            make.leading.equalTo(customAlertView.snp.leading)
            make.trailing.equalTo(customAlertView.snp.trailing)
            make.bottom.equalTo(buttonContainerView.snp.top).offset(-0.5)
            make.height.equalTo(0.5)
        }
    }
    
    private func layoutButtonContainerView() {
        buttonContainerView = UIView.init()
        addSubview(buttonContainerView)
        
        buttonContainerView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(30)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
            make.bottom.equalTo(customAlertView.snp.bottom)
            make.height.equalTo(40)
        }
    }

    private func layoutTitleLabel(title: String) {

        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.g1()
        titleLabel.font = UIFont.boldSystemFont(ofSize: AlertViewConstant.titleLabelFontSize)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(customAlertView.snp.top).offset(verticalInterval)
            make.centerX.equalTo(self.snp.centerX)
            make.leading.equalTo(self.snp.leading).offset(55)
            make.trailing.equalTo(self.snp.trailing).offset(-55)
        }
    }
    
    private func layoutCustomAlertView() {
        customAlertView = UIView()
        customAlertView.layer.cornerRadius = 4
        customAlertView.backgroundColor = UIColor.white
        addSubview(customAlertView)
        customAlertView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(30)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    private func layoutMessageLabel(message: String) {
        messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: AlertViewConstant.messageLabelFontSize)
        messageLabel.textColor = UIColor.g1()
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(buttonContainerView.snp.top).offset(-25)
            make.leading.equalTo(buttonContainerView.snp.leading).offset(25)
            make.trailing.equalTo(buttonContainerView.snp.trailing).offset(-25)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
    }
    
    private func layoutTitleLabelWithoutMessage(title: String) {
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.g1()
        titleLabel.font = UIFont.boldSystemFont(ofSize: AlertViewConstant.actionBtnFontSize)
        addSubview(titleLabel)
        titleLabel.textAlignment = .center

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(customAlertView.snp.top).offset(35)
            make.leading.equalTo(customAlertView.snp.leading).offset(25)
            make.trailing.equalTo(customAlertView.snp.trailing).offset(-25)
            make.bottom.equalTo(buttonContainerView.snp.top).offset(-35)
        }
    }
    
    private func layoutActions() {
        let actionsCount = actionArray.count
        let actionWidth = (UIScreen.mainWidth - 60)/CGFloat(actionsCount)

        for (index, action) in actionArray.enumerated() {
            let actionBtn = UIButton()
            actionBtn.titleLabel?.text = action.title
            actionBtn.setTitleColor(UIColor.g1(),for: .normal)
           buttonContainerView.addSubview(actionBtn)

            //更新字典
            dict.updateValue(actionArray[index], forKey: actionBtn)
            
            if action.style != .cancel {
                actionBtn.setTitleColor(UIColor.b1(),for: .normal)
            }
            actionBtn.setTitle(action.title, for: .normal)
            actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: AlertViewConstant.actionBtnFontSize)
            actionBtn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            let verticalLine = UIView()
            verticalLine.backgroundColor = UIColor.g4()
            buttonContainerView.addSubview(verticalLine)
            //隐藏最后一个 line
            if index == actionArray.count - 1{
                verticalLine.isHidden = true
            }
            
            verticalLine.snp.makeConstraints({ (make) in
                make.left.equalTo(buttonContainerView.snp.left).offset(CGFloat(index + 1) * actionWidth)
                make.top.equalTo(buttonContainerView.snp.top)
                make.bottom.equalTo(buttonContainerView.snp.bottom)
                make.width.equalTo(0.5)
            })
            
            actionBtn.snp.makeConstraints({ (make) in
                make.top.equalTo(buttonContainerView.snp.top)
                make.bottom.equalTo(buttonContainerView.snp.bottom)
                make.width.equalTo(actionWidth)
                make.left.equalTo(buttonContainerView.snp.left).offset(CGFloat(index) * actionWidth)
                make.height.equalTo(40)
            })
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: AlertViewConstant.animationDuration, animations: {
            self.alpha = 0
            }, completion: { (true) in
                self.removeFromSuperview()
        })
    }

    func addMask() {    //增加遮罩效果
        let layer = CALayer.init()
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0.2
        layer.bounds = UIScreen.main.bounds
        layer.anchorPoint = CGPoint(x: 0, y: 0)
        self.layer.insertSublayer(layer, below: customAlertView.layer)
    }
    
    func addAction(_ action: AlertAction) {
        guard let _ = action.title else {
            self.verticalInterval = 35.0
            return
        }
        
        if action.style == .cancel {
            actionArray.insert(action, at: 0)
        } else {
            actionArray.append(action)
        }

        verticalInterval = 25.0
    }
    
    func btnClick(sender: UIButton) {
        guard let value = dict[sender] else {
            return
        }
        value.actionClosure(value)
        self.dismiss()
    }
    
    func showIn(view:UIView) {//添加到 view
        layoutActions()
        addMask()
        view.addSubview(self)
        self.customAlertView.alpha = 0
        UIView.animate(withDuration: AlertViewConstant.animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.customAlertView.alpha = 1
            }, completion: { (true) in
        })
    }
    
    func show() {//添加到 window
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        layoutActions()
        addMask()
        keyWindow.addSubview(self)
        self.customAlertView.alpha = 0
        UIView.animate(withDuration: AlertViewConstant.animationDuration, animations: {
            self.customAlertView.alpha = 1
        }, completion: { (ture) in
        })
    }
}

//MARK: - AlertAction
public enum AlertActionStyle : Int {
    case confirm
    case cancel
    case `default`
}

class AlertAction {
    
    //MARK: - Properties
    typealias callback = (AlertAction) -> ()
    open var title: String?
    open var style: AlertActionStyle
    var actionClosure: callback
    
    init(title: String?, style: AlertActionStyle, handler: @escaping callback) {
        self.title = title
        self.style = style
        self.actionClosure = handler
    }
}
