Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbYBZPtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbYBZPtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763088AbYBZPtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:49:36 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:42406 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763089AbYBZPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:49:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=bojhYoMd2USPMMK5XVEeMQ==:17
 a=ggR3LWzlu2gNnT3dWcIA:9 a=4QVpO8ECN7xhnQDhuLBVV4sBsEEA:4 a=ZaGerQNKEe0A:10
 a=8t_6ZPhla3UA:10
From: kelk1@comcast.net (Quel Qun)
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Tue, 26 Feb 2008 15:49:31 +0000
Message-Id: <022620081549.2196.47C4350B0007A955000008942200761438CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -------------- Original message ----------------------
From: Marcel Holtmann <marcel@holtmann.org>
> Hi Quel,
> 
> > Bad news: I still cannot use the device.
> >
> > hcitool inq, hcitool scan, hcitool name <btaddr> and hcitool info  
> > <btaddr>
> > commands work.
> >
> > hcitool cc <btaddr>, sdptool <btaddr>, rfcomm connect command fail,  
> > most of them
> > with a 'Connection reset by peer' error.
> 
> what does "hciconfig hci0 version" tell you about your device? Some of  
> the none major based Bluetooth chips are broken and might need an  
> extra tweak within the USB driver.
> 

Marcel,

# hciconfig hci0 version
hci0:	Type: USB
	BD Address: 00:03:0D:00:15:47 ACL MTU: 192:8 SCO MTU: 64:8
	HCI Ver: 1.1 (0x1) HCI Rev: 0xbc LMP Ver: 1.1 (0x1) LMP Subver: 0xbc
	Manufacturer: Cambridge Silicon Radio (10)

# lsusb | grep Cambridge
Bus 003 Device 002: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)

This device works fine in 2.6.23.1 and got broken circa 2.6.24 rcs.

Thank you,
--
kk1
