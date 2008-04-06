Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYDFUX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYDFUX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYDFUXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:23:15 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:36945 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756094AbYDFUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:23:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=kPHqnA1bTjj5Ejv7DAjIya7d5MXlsQPHCrYYzQvBQru/Oibqe3pm0ZeiyZkfuRVy;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <47F9312D.7020706@earthlink.net>
Date: Sun, 06 Apr 2008 16:23:09 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: hp usb printer not usable after boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec797babc3177d25c083fa2ca98c8ad321de350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.77.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

With kernels 2.6.24.4-64.fc8 2.6.24.3-50.fc8 I can't access my hp officejet k-60 
unless I unplug the usb cable and plug it back it. I never use to have this 
problem. I can't print to it or access it with hp-tools.

**** with kernel 2.6.24.3-50.fc8 error when trying to access printer with hp-tools

Apr  6 15:19:32 joker python: io/hpmud/musb.c 135: unable get_string_descriptor 
-1: Operation not
  permitted
Apr  6 15:19:32 joker python: io/hpmud/musb.c 603: invalid product id string ret=-1
Apr  6 15:19:32 joker python: io/hpmud/musb.c 1057: unable to open 
hp:/usb/OfficeJet_K60?serial=M
Y0BGC40S6OH
Apr  6 15:19:32 joker python: hp-toolbox[20912]: error: Unable to communicate 
with device (code=1
2): hp:/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:19:32 joker python: hp-toolbox[20912]: warning: Device not found
Apr  6 15:19:33 joker OfficeJet_K60?serial=MY0BGC40S6OH: io/hpmud/musb.c 135: 
unable get_string_d
escriptor -1: Operation not permitted
Apr  6 15:19:33 joker OfficeJet_K60?serial=MY0BGC40S6OH: io/hpmud/musb.c 603: 
invalid product id
string ret=-1
Apr  6 15:19:33 joker OfficeJet_K60?serial=MY0BGC40S6OH: io/hpmud/musb.c 1057: 
unable to open hp:
/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:19:33 joker OfficeJet_K60?serial=MY0BGC40S6OH: prnt/backend/hp.c 636: 
INFO: open device
  failed; will retry in 30 seconds...
Apr  6 15:19:37 joker python: io/hpmud/musb.c 135: unable get_string_descriptor 
-1: Operation not
  permitted
Apr  6 15:19:37 joker python: io/hpmud/musb.c 603: invalid product id string ret=-1
Apr  6 15:19:37 joker python: io/hpmud/musb.c 1057: unable to open 
hp:/usb/OfficeJet_K60?serial=M
Y0BGC40S6OH
Apr  6 15:19:37 joker python: hp-toolbox[20912]: error: Unable to communicate 
with device (code=1
2): hp:/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:20:03 joker OfficeJet_K60?serial=MY0BGC40S6OH: io/hpmud/musb.c 135: 
unable get_string_descriptor -1: Operation not permitted
Apr  6 15:20:03 joker OfficeJet_K60?serial=MY0BGC40S6OH: io/hpmud/musb.c 603: 
invalid product id string ret=-1
Apr  6 15:20:03 joker OfficeJet_K60?serial=MY0BGC40S6OH: io/hpmud/musb.c 1057: 
unable to open hp:/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:20:03 joker OfficeJet_K60?serial=MY0BGC40S6OH: prnt/backend/hp.c 636: 
INFO: open device failed; will retry in 30 seconds...
... unplugged device
Apr  6 15:20:12 joker kernel: usb 1-2: USB disconnect, address 2
Apr  6 15:20:12 joker kernel: usblp0: removed
... plugged back in and no more errors
Apr  6 15:20:14 joker kernel: usb 1-2: new full speed USB device using uhci_hcd 
and address 3
Apr  6 15:20:14 joker kernel: usb 1-2: configuration #1 chosen from 1 choice
Apr  6 15:20:14 joker kernel: usblp0: USB Bidirectional printer dev 3 if 0 alt 0 
proto 3 vid 0x03F0 pid 0x0511

booted new kernel 2.6.24.4-64.fc8
Apr  6 15:56:11 joker kernel: usblp0: USB Bidirectional printer dev 2 if 0 alt 0 
proto 3 vid 0x03F0 pid 0x0511
Apr  6 15:56:11 joker kernel: usbcore: registered new interface driver usblp


*** tried to access with hp-tools
Apr  6 15:57:36 joker python: io/hpmud/musb.c 135: unable get_string_descriptor 
-1: Operation not
  permitted
Apr  6 15:57:36 joker python: io/hpmud/musb.c 603: invalid product id string ret=-1
Apr  6 15:57:36 joker python: io/hpmud/musb.c 1057: unable to open 
hp:/usb/OfficeJet_K60?serial=M
Y0BGC40S6OH
Apr  6 15:57:36 joker python: hp-toolbox[4368]: error: Unable to communicate 
with device (code=12
): hp:/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:57:36 joker python: hp-toolbox[4368]: warning: Device not found
Apr  6 15:57:36 joker python: io/hpmud/musb.c 135: unable get_string_descriptor 
-1: Operation not
  permitted
Apr  6 15:57:36 joker python: io/hpmud/musb.c 603: invalid product id string ret=-1
Apr  6 15:57:36 joker python: io/hpmud/musb.c 1057: unable to open 
hp:/usb/OfficeJet_K60?serial=M
Y0BGC40S6OH
Apr  6 15:57:36 joker python: hp-toolbox[4368]: error: Unable to communicate 
with device (code=12
): hp:/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:57:36 joker python: hp-toolbox[4368]: warning: Device not found
Apr  6 15:57:47 joker python: io/hpmud/musb.c 135: unable get_string_descriptor 
-1: Operation not
  permitted
Apr  6 15:57:47 joker python: io/hpmud/musb.c 603: invalid product id string ret=-1
Apr  6 15:57:47 joker python: io/hpmud/musb.c 1057: unable to open 
hp:/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:57:47 joker python: hp-toolbox[4368]: error: Unable to communicate 
with device (code=12): hp:/usb/OfficeJet_K60?serial=MY0BGC40S6OH
Apr  6 15:57:47 joker python: hp-toolbox[4368]: warning: Device not found
Apr  6 15:57:53 joker python: io/hpmud/musb.c 135: unable get_string_descriptor 
-1: Operation not:
**** unplugged device
Apr  6 15:58:37 joker kernel: usb 1-2: USB disconnect, address 2
Apr  6 15:58:37 joker kernel: usblp0: removed
**** plugged backin
Apr  6 15:58:41 joker kernel: usb 1-2: new full speed USB device using uhci_hcd 
and address 3
Apr  6 15:58:41 joker kernel: usb 1-2: configuration #1 chosen from 1 choice
Apr  6 15:58:41 joker kernel: usblp0: USB Bidirectional printer dev 3 if 0 alt 0 
proto 3 vid 0x03F0 pid 0x0511
**** now works fine with hp-tools



-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


