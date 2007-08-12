Return-Path: <linux-kernel-owner+w=401wt.eu-S934929AbXHLNIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbXHLNIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932795AbXHLNIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:08:44 -0400
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:58695 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbXHLNIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:08:43 -0400
Subject: Kernel 2.5.23-rc2-git4 Boot Failure
From: Chris Holvenstot <cholvenstot@comcast.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 12 Aug 2007 08:10:45 -0500
Message-Id: <1186924245.6478.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Last night I built the 2.6.23-rc2-git4 kernel but could not get it to
boot.  I rebuilt it this morning from scratch on the chance that I made
a finger-check the first time through and screwed the pooch.

After the second attempt to build this i still could not boot the
system.  I received the following messages (hand copied - not sure how
to capture messages during the early phases of a boot)

PCI: cannot allocate resource region 0 of device 000:00:04.0
PCI: cannot allocate resource region 4 of device 000:00:06.0
Loading, please wait
ehci_hcd 0000:00:02.1 init 0000:00:02.1 fail, -16
ohci_hcd 0000:00:02.0 init 0000:00:02.0 fail, -16

The system cranks for a while and then I see the messages:

hdb: <4>hdb: dma_timer_expiry: DMA status = oFF

and thereafter 

hdb: dma_timer_expiry: DMA status = oFF

is issued every 10 seconds.

The hdb drive is where the system (root partition) is located

My basic configuration looks like:

* AMD_64 X2 4600+ (older 939 pin unit)
* MSI K8n NEO 4 motherboard 
* 2 gig memory across 4 512 modules
* hda: IDE-DVD ROM 16x, ATAPI CD/DVD-ROM drive
* hdb: WDC WD2500JB-55REA0, ATA DISK drive
* hdc: WDC WD2000BB-22GUC0, ATA DISK drive
* hdd: Maxtor 6Y120P0, ATA DISK drive
* ata1: SATA max UDMA/133 cmd 0xf884a480 ctl 0xf884a4a0 bmdma 0x0001cc00
irq 19
* ata2: SATA max UDMA/133 cmd 0xf884a580 ctl 0xf884a5a0 bmdma 0x0001cc08
irq 19
* Nvidia GeForce 7600 GS Video Card
* Nvidia CK804 chip set

All hard drives formatted EXT3
Using generic "nv" video driver (NOT Nvidia's driver)

System boots and runs good on 2.6.23-rc1 through 2.6.23-rc2-git3

The base system I am using is Ubuntu's 7.04 with minor modifications

I hope that this provides enough information to start with.  If I have
left anything important out please let me know what you would llike to
see (and maybe where to get it)








