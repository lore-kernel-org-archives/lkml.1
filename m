Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbXF2L1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbXF2L1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbXF2L06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:26:58 -0400
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:60077 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbXF2L04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:26:56 -0400
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 07:26:56 EDT
Message-ID: <31585.194.237.142.7.1183115734.squirrel@ncircle.nullnet.fi>
In-Reply-To: <4683BF16.40905@gmx.de>
References: <4683BF16.40905@gmx.de>
Date: Fri, 29 Jun 2007 14:15:34 +0300 (EEST)
Subject: Re: 2.6.22-rc6 spurious hangs
From: "Tomi Orava" <Tomi.Orava@ncircle.nullnet.fi>
To: "Thomas Sattler" <tsattler@gmx.de>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Ingo Molnar" <mingo@elte.hu>
User-Agent: SquirrelMail/1.4.10a-1.fc7
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
X-Priority: 3 (Normal)
Importance: Normal
Content-Transfer-Encoding: 8BIT
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

> I'm observing seldom hangs with linux 2.6. I can't tell when exactly it
> happened the first time, I think somewhere around 2.6.16 or 2.6.17. I
> see it about once or twice a month. With absolutely nothing in the logs.
> So far I asked for help:

<snip>

> The box I talk about is an IBM T41p with 1.7GHz Pentium M and 512MB RAM.
> The distribution in use is gentoo, quite up to date. Attached to the box
> is an USB2.0 DVB-T receiver (Cinergy T², Terratec).
>
> In rare cases the keyboard stops working when the T² stops streaming DVB
> to the box. It happens when I record the stream to disk as well as when
> I stream it to mplayer.

I just wanted you to know that you are not alone with this problem.
I've seen the same symptoms on my parents machine during the last 1-2 months
--> ie. keyboard hangs completely, mouse works and the host either hangs
completely sooner or later with only the following usb debug messages in
the logs (pasted below).

I believe that there is certainly some sort of bug in cinergyT2-driver
as I've not seen the hang happen whenever the cinergyT2 usb-receiver
has been disconnected from the machine.

Host configuration is:
2.6.22-rc4-git4 kernel + latest DVB drivers from v4l-dvb tree
(previously also tested with FC6 kernels with same symptoms)
MythTV-software (from devel SVN)

Asus P4P800-E motherboard (ich5 & PDC20378 sata-controllers)
1GB ram
Intel P4 2.8MHz
Terratec Cinergy T2 dvb-t receiver

Regards,
Tomi Orava


--------------------------------------------------
ehci_hcd 0000:00:1d.7: devpath 1 ep2in 3strikes
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0002
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001002 POWER sig=se0 CSC
hub 1-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
usb 1-1: USB disconnect, address 2
usb 1-1: unregistering device
usb 1-1: usb_disable_device nuking all URBs
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a3c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a340 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a2c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a240 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f71a6c40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f7e7f0c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c37dc0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c37e40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f71a6d40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9af40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f71a61c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9ae40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9adc0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9ad40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9acc0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9ac40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9abc0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9ab40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9aac0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9aa40 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a9c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a940 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a8c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a840 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a7c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a740 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a6c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a640 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a5c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a540 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a4c0 pipe c0010280 ep2in-bulk
ehci_hcd 0000:00:1d.7: shutdown urb f6c9a440 pipe c0010280 ep2in-bulk
cinergyT2: cinergyt2_submit_stream_urb(): urb submission failed (err = -19)!
last message repeated 31 times
---------------------------------------------------------------------
-- 


