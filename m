Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYJMUTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYJMUTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYJMUTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:19:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:37211 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYJMUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:subject:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=u16fBoK+Z4EbrnJjFlQ9jd/YhNyXCDvdLbFZdBaq00voNkLa5EXU3n6HPpe1QB1l6z
         z8kO0qgFjWOF5Qb9nla6PqUtnR3PS2qPKGV/6DQypg6ofGE/918E71JN2VMJW7AHvnWr
         vtm1QV3sGr3LdHmq2i5LFmwtW4SMDK6KzmfTw=
Message-ID: <48F3AD5A.2080504@gmail.com>
Date: Mon, 13 Oct 2008 22:19:38 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080929)
MIME-Version: 1.0
To: "Kernel, " <linux-kernel@vger.kernel.org>
Subject: 2.6.27 gspca driver fails with Trust WB-1400T
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

i have a Trust 1400T perfectly working on 2.6.26 using external module
(media-video/gspcav1-20071224 is the gentoo version so it's that day
snapshot.)

Upgrading to 2.6.27 kernel, using integrated kernel driver

i get:

gspca: main v2.2.0
registered                                                                                           

usbcore: registered new interface driver
conex                                                                          

conex:
registered                                                                                                       

usbcore: registered new interface driver
etoms                                                                          

etoms:
registered                                                                                                       

usbcore: registered new interface driver
mars                                                                           

mars:
registered                                                                                                        

usbcore: registered new interface driver
ov519                                                                          

ov519:
registered                                                                                                       

usbcore: registered new interface driver
pac207                                                                         

pac207:
registered                                                                                                      

usbcore: registered new interface driver
pac7311                                                                        

pac7311:
registered                                                                                                     

usbcore: registered new interface driver
sonixb                                                                         

sonixb:
registered                                                                                                      

usbcore: registered new interface driver
sonixj                                                                         

sonixj:
registered                                                                                                      

usbcore: registered new interface driver
spca500                                                                        

spca500:
registered                                                                                                     

usbcore: registered new interface driver
spca501                                                                        

spca501:
registered                                                                                                     

usbcore: registered new interface driver
spca505                                                                        

spca505:
registered                                                                                                     

usbcore: registered new interface driver
spca506                                                                        

spca506:
registered                                                                                                     

usbcore: registered new interface driver
spca508                                                                        

spca508:
registered                                                                                                     

usbcore: registered new interface driver
spca561                                                                        

spca561:
registered                                                                                                     

usbcore: registered new interface driver
sunplus                                                                        

sunplus:
registered                                                                                                     

usbcore: registered new interface driver
stk014                                                                         

stk014:
registered                                                                                                      

usbcore: registered new interface driver
t613                                                                           

t613:
registered                                                                                                        

usbcore: registered new interface driver
tv8532                                                                         

tv8532:
registered                                                                                                      

usbcore: registered new interface driver
vc032x                                                                         

vc032x:
registered                                                                                                      

usbcore: registered new interface driver
zc3xx                                                                          

zc3xx: registered                                    

gspca: probing
093a:2468                                                                                                

pac207: Pixart Sensor ID 0x27 Chips ID
0x08                                                                             

pac207: Pixart PAC207BCA Image Processor and Control Chip detected
(vid/pid 0x093A:0x2468)                              
gspca: probe ok     

i have node device created, but picture is totally corrupted, with skype
(sorry!) i have a green and black window,
with mplayer or kopete i have a black one, while before with old driver
it was working perfectly.
Any hints?

lsusb
Bus 002 Device 002: ID 093a:2468 Pixart Imaging, Inc. Easy Snap Snake
Eye WebCam

Here i read my device works, but it's not my case.
https://fedoraproject.org/wiki/Features/BetterWebcamSupport

i'm running a core2 in 64bit mode.

Please CC me i'm not subscribed

---
Patrizio Bassi
www.patriziobassi.it


