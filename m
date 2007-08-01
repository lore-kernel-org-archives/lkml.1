Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbXHASGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbXHASGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbXHASGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:06:21 -0400
Received: from fallback.us4.outblaze.com ([205.158.62.120]:60154 "EHLO
	fallback.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763455AbXHASGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:06:20 -0400
X-OB-Received: from unknown (205.158.62.81)
  by wfilter2.us4.outblaze.com; 1 Aug 2007 17:41:03 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Ash Willis" <ashwillis@programmer.net>
To: rafalbilski@interia.pl
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, tiwai@suse.de
Date: Wed, 1 Aug 2007 12:41:03 -0500
Subject: Re: CS5530 Alsa driver fails
X-Originating-Ip: 79.65.38.5
X-Originating-Server: ws1-2.us4.outblaze.com
Message-Id: <20070801174103.D03341F50B1@ws1-2.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Hello,
>
>Linux: 2.6.23-rc1-git3
>Hardware: CX5530
>
>After "modprobe snd-cs5530" I have:
>CS5530: XpressAudio at 0x220
>CS5530: MPU at 0x330
>CS5530: IRQ: 9 DMA8: 0 DMA16: 5
>sb: can't grab irq 9
>CS5530: Could not create SoundBlaster
>CS5530_Audio: probe of 0000:00:12.3 failed with error -16
>Thank You
>Rafa&#322;
>
>~ $ cat /proc/interrupts
>           CPU0
>  0:      26624    XT-PIC-XT        timer
>  2:          0    XT-PIC-XT        cascade
>  4:        428    XT-PIC-XT        serial
>  8:          0    XT-PIC-XT        rtc
>  9:      10793    XT-PIC-XT        ohci_hcd:usb1
> 10:       1326    XT-PIC-XT        eth0
>NMI:          0
>ERR:          0
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Hi Rafa&#322;,
It seems that you're already using irq 9 for another device, and as Alan says
the cs5530 audio device doesn't seem to do irq sharing. It seems to me that you
need to go into your BIOS settings at startup and tell the device to use an irq
line that's not already in use by some other device. Can you please let me know
if this works?

The ALSA CS5530 driver is one that I ported from Alan's OSS Kahlua driver, so
there may be some things that I've missed. If the above advice doesn't work,
please confirm whether or not the device is functioning correctly in your
current set up with Alan's original OSS driver.

Thanks,

Ash


-- 
We've Got Your Name at http://www.mail.com!
Get a FREE E-mail Account Today - Choose From 100+ Domains

