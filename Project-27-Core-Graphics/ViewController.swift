//
//  ViewController.swift
//  Project-27-Core-Graphics
//
//  Created by verebes on 11/10/2018.
//  Copyright © 2018 A&D Progress. All rights reserved.
//

import UIKit

enum Shape {
    case circle
    case rectangle
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private var currentDrawType = 0
    
    var rendererSize: CGSize {
        get {
            return CGSize(width: view.bounds.width - 50, height: view.bounds.height / 2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        drawRectangle()
        drawShape(.rectangle)
    }

    
    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawShape(.rectangle)
        case 1:
            drawShape(.circle)
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        default:
            break
        }
    }
    
    private func drawShape(_ shape: Shape) {
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let img = renderer.image { (context) in
            
            let rect = CGRect (x: 5, y: 5, width: view.bounds.width - 60, height: view.bounds.height / 2 - 10)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            switch shape {
            case .rectangle:
                context.cgContext.addRect(rect)
            case .circle:
                context.cgContext.addEllipse(in: rect)
            }
            context.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
    private func drawCheckerBoard() {
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let img = renderer.image { (context) in
            context.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        context.cgContext.fill(CGRect(x: col * 50, y: row * 50, width: 50, height: 50))
                    }
                }
            }
        }
        imageView.image = img
    }
    
    private func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let img = renderer.image { (context) in
            context.cgContext.translateBy(x: 128, y: 128)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                context.cgContext.rotate(by: CGFloat(amount))
                context.cgContext.addRect(CGRect(x: -64, y: -64, width: 128, height: 128))
            }
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        imageView.image = img
    }
    //PAGE 613
    
    private func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let img = renderer.image { (context) in
            context.cgContext.translateBy(x: 128, y: 128)
            
            var first = true
            var length: CGFloat = 128
            
            for _ in 0 ..< 128 {
                context.cgContext.rotate(by: CGFloat.pi / 2)
                
                if first {
                    context.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    context.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    private func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let img = renderer.image { (context) in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 22), NSAttributedString.Key.paragraphStyle: paragraphStyle]
            
            let text: NSString = "The best-laid schemes o'\nmice an' men gangaft agley"
            text.draw(with: CGRect(x: 0, y: 32, width: rendererSize.width, height: 250), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
//            text.draw(in: CGRect(x: 0, y: 32, width: view.bounds.width, height: 250), withAttributes: attributes)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: (view.bounds.width / 2) - 100, y: 150))
        }
        imageView.image = img
    }

}

