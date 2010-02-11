Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0BKVMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:12:16 -0500
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:34934 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236Ab0BKVMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:12:12 -0500
From: ST <st@iss.tu-darmstadt.de>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: 2.6.33-rc7 problems
Date: Thu, 11 Feb 2010 22:11:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-00025-g08c4f1b; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201002092306.07449.st@iss.tu-darmstadt.de> <4B7354D9.50909@gmail.com>
In-Reply-To: <4B7354D9.50909@gmail.com>
MIME-Version: 1.0
Message-Id: <201002112211.51177.st@iss.tu-darmstadt.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-PMX-TU: seen v0.99a by 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.11.205722
X-PMX-SPAMCHECK: outgoing mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert 

Thanks for your reply. 
> Well, the card reader apparently reports medium not present.. is there
> anything in there? how is it not working?
Well thats exactly the problem since there is a CF Card plugged into the 
reader. 
I  just checked with Fedora 12 and 2.6.31. The output there looks
like this (and i am 100% sure its not an HW error. Since i plugged out the
USB plug not the CF card an use the same USB port while dualbooting):
usb 1-4.3: SerialNumber: 058F63646476
usb 1-4.3: configuration #1 chosen from 1 choice
scsi9 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 7
usb-storage: waiting for device to settle before scanning
generic-usb: probe of 0003:058F:6364.0004 failed with error -22
usb-storage: device scan complete
scsi 9:0:0:0: Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0
scsi 9:0:0:1: Direct-Access     Generic- Compact Flash    1.01 PQ: 0 ANSI: 0
scsi 9:0:0:2: Direct-Access     Generic- SM/xD-Picture    1.02 PQ: 0 ANSI: 0
scsi 9:0:0:3: Direct-Access     Generic- MS/MS-Pro        1.03 PQ: 0 ANSI: 0 
CCS
sd 9:0:0:0: Attached scsi generic sg3 type 0
sd 9:0:0:1: Attached scsi generic sg4 type 0
sd 9:0:0:2: Attached scsi generic sg5 type 0
sd 9:0:0:3: Attached scsi generic sg6 type 0
sd 9:0:0:3: [sdf] Attached SCSI removable disk
sd 9:0:0:1: [sdd] 15858864 512-byte logical blocks: (8.11 GB/7.56 GiB)

With my config it stops with :
scsi 8:0:0:0: Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0

So either some CF Card stuff is missing (old ata stuff needed?) or there is
some other SCSI stuff going on i don't understand... 
Since the device scan with my strange config never completes it never has any 
devices to offer...

I also checked with 2.6.32 with my config. Same bad result, so i guess it is 
not a regression.

Best regards
ST
