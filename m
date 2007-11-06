Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbXKFRu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbXKFRu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXKFRuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:50:20 -0500
Received: from wrzx28.rz.uni-wuerzburg.de ([132.187.3.28]:45675 "EHLO
	mailrelay.rz.uni-wuerzburg.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754219AbXKFRuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:50:16 -0500
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 12:50:15 EST
Message-ID: <4730A379.9060706@durtro.de>
Date: Tue, 06 Nov 2007 18:25:13 +0100
From: Markus Hirschmann <mh@durtro.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: jayakumar.video@gmail.com, Christian Magnusson <mag@mag.cx>
Cc: dtor@mail.ru, mchehab@infradead.org, linux-kernel@vger.kernel.org
Subject: Problems using quickcam_messenger on ARM (FYI)
Content-Type: multipart/mixed;
 boundary="------------010108050206040400080709"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010108050206040400080709
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello Kernel-Developer,

Module quickcam_messenger seems to be broken (tried 2.6.18 and 2.6.22)
on 2 different NSLU2 (ARM). Picture is attached. Same kernel and module 
can be used without any problems on x86 here. I don't have any ARM 
device beside the NSLU2, so I cannot check.

The solution was to use Christian Magnusson's quickcam module. 
Everything worked without any problem. Webcam is:

Bus 003 Device 005: ID 046d:08f0 Logitech, Inc. QuickCam Messenger

Best regards and thanks for your work!

Markus

Kernel is:
Linux secure 2.6.18-5-ixp4xx #1 Thu Oct 11 20:42:54 UTC 2007 armv5tel
GNU/Linux

Logs with quickcam_messenger:

Nov  5 13:35:54 secure kernel: Linux video capture interface: v2.00
Nov  5 13:35:54 secure kernel:
drivers/media/video/usbvideo/quickcam_messenger.c: Logitech Quickcam
Messenger USB v0.01
Nov  5 13:35:54 secure kernel: videodev: "QCM USB Camera" has no release
callback. Please fix your driver for proper sysfs support, see
http://lwn.net/Articles/36850/
Nov  5 13:35:54 secure kernel: drivers/media/video/usbvideo/usbvideo.c:
QCM on /dev/video0: canvas=320x240 videosize=320x240
Nov  5 13:35:55 secure kernel: input: QCM button as /class/input/input1
Nov  5 13:35:55 secure kernel: usbcore: registered new interface driver QCM
Nov  5 13:35:55 secure kernel: swapped image found
Nov  5 13:35:55 secure kernel: Image loaded to NPE-B Func:0, Rel: 2:1,
Status: 82c00000
Nov  5 13:35:55 secure kernel: usbcore: registered new interface driver
snd-usb-audio

Nov  5 13:36:13 secure motion: [0] Processing thread 0 - config file
/etc/motion/motion.conf
Nov  5 13:36:13 secure motion: [1] Thread is from /etc/motion/motion.conf
Nov  5 13:36:13 secure motion: [1] Thread started
Nov  5 13:36:13 secure motion: [1] Failed with YUV420P, trying YUV422
palette: Invalid argument
Nov  5 13:36:13 secure motion: [1] Failed with YUV422, trying RGB24
palette: Invalid argument
Nov  5 13:37:07 secure motion: [1] Motion terminating
Nov  5 13:37:07 secure kernel: drivers/media/video/usbvideo/usbvideo.c:
Packet Statistics: Total=54784. Empty=0. Usage=100%%
Nov  5 13:37:07 secure kernel: drivers/media/video/usbvideo/usbvideo.c:
Transfer Statistics: Transferred=41MB Usage=78%%
Nov  5 13:37:41 secure motion: [0] Processing thread 0 - config file
/etc/motion/motion.conf
Nov  5 13:37:41 secure motion: [1] Thread is from /etc/motion/motion.conf
Nov  5 13:37:41 secure motion: [1] Thread started
Nov  5 13:37:41 secure motion: [1] Failed with YUV420P, trying YUV422
palette: Invalid argument
Nov  5 13:37:41 secure motion: [1] Failed with YUV422, trying RGB24
palette: Invalid argument
Nov  5 13:37:46 secure motion: [1] sync error in proc 2011: Interrupted
system call
Nov  5 13:37:46 secure motion: [1] Motion terminating
Nov  5 13:37:46 secure kernel: drivers/media/video/usbvideo/usbvideo.c:
Packet Statistics: Total=5024. Empty=0. Usage=100%%
Nov  5 13:37:46 secure kernel: drivers/media/video/usbvideo/usbvideo.c:
Transfer Statistics: Transferred=3763KB Usage=74%%
Nov  5 13:38:09 secure kernel: usb 2-1: USB disconnect, address 2
Nov  5 13:38:09 secure kernel: drivers/media/video/usbvideo/usbvideo.c:
USB camera disconnected.

--------------010108050206040400080709
Content-Type: image/jpeg;
 name="test3.jpg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="test3.jpg"

/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRof
Hh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwh
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAAR
CADwAUADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAA
AgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWG
h4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl
5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREA
AgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYk
NOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk
5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDzrUpcxamfN6yOv+t6/u14/wBb+nP+6egi
vp8wah++6u4/13X5F4/1vP05+h6CXUZf3Wpfvusjj/W9f3a8f6z9Of8AdPQR38v7vUf33V3H
+t6/IvH+t/Tn6HoCjtD1/wDkQl9r1F1CX9zqP73rI4/1vX5F4/1n6c/7p6UahL+61H971kcf
63r8i8f6z9Of93tRqEv7rUf3vWRx/revyLx/rP05/wB3sE1CX91qP73rI4/1nX5F4/1n6c/T
sCj9j1/+RCX2vUbqE3y6j++6u4/1vX5F4/1v6c/TsHahL+51H971kcf6zr8i8f6z9Of93tTd
Ql+TUT53WRx/revyLx/rf05+h6B2oS/udR/e9ZHH+s6/IvH+s/Tn/d7UUf8Al36//IhL7XqG
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
c/jn6n//2Q==
--------------010108050206040400080709--
