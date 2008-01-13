Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYAMWyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYAMWyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYAMWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:54:06 -0500
Received: from hermes.jacobs-university.de ([212.201.44.23]:45292 "EHLO
	hermes.jacobs-university.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbYAMWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:54:04 -0500
X-Greylist: delayed 2074 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2008 17:54:03 EST
From: Georgi Chulkov <g.chulkov@jacobs-university.de>
To: linux-kernel@vger.kernel.org
Subject: ATA device reset, shoud I be concerned?
Date: Mon, 14 Jan 2008 00:19:20 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200801140019.20668.g.chulkov@jacobs-university.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

During heavy disk load on my laptop, sometimes the IDE disk will pause for a 
second and then continue. I get this in my kernel log:

[ 9031.028000] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 
frozen
[ 9031.028000] ata1.00: cmd c8/00:08:90:ca:ce/00:00:00:00:00/e0 tag 0 cdb 0x0 
data 4096 in
[ 9031.028000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 
(timeout)
[ 9036.068000] ata1: port is slow to respond, please be patient (Status 0xd0)
[ 9041.052000] ata1: device not ready (errno=-16), forcing hardreset
[ 9041.052000] ata1: soft resetting port
[ 9041.232000] ata1.00: configured for UDMA/100
[ 9041.232000] ata1: EH complete
[ 9041.248000] sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
[ 9041.248000] sd 0:0:0:0: [sda] Write Protect is off
[ 9041.248000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 9041.248000] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA

My question: What is this telling me, and do I need to be concerned? 
Everything continues to work normally after the message: no I/O errors, no 
fsck errors, etc.

I've seen some similar reports on the mailing list, but they include slightly 
different messages. I would appreciate any information!

uname -a (on Kubuntu Gutsy, CPU is a single-core 32-bit Pentium M):

Linux superfly 2.6.22-14-386 #1 Tue Dec 18 07:34:24 UTC 2007 i686 GNU/Linux

lspci:

00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller 
(rev 03)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 
03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI 
Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge 
(rev 01)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 
01)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
01:00.0 VGA compatible controller: nVidia Corporation NV28 [GeForce4 Ti 4200 
Go AGP 8x] (rev a1)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5705M Gigabit 
Ethernet (rev 01)
02:01.0 CardBus bridge: Texas Instruments PCI7510 PC card Cardbus Controller 
(rev 01)
02:01.2 FireWire (IEEE 1394): Texas Instruments PCI7410,7510,7610 OHCI-Lynx 
Controller
02:01.3 System peripheral: Texas Instruments PCI7410,7510,7610 PCI Firmware 
Loading Function
02:03.0 CardBus bridge: Texas Instruments PCI1410 PC card Cardbus Controller 
(rev 01)

Thanks!
