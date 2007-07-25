Return-Path: <linux-kernel-owner+w=401wt.eu-S1764865AbXGYIHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764865AbXGYIHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXGYIHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:07:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbXGYIHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:07:15 -0400
Date: Wed, 25 Jul 2007 01:06:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Khelben Blackstaff" <eye.of.the.8eholder@gmail.com>
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: Problem with saa7134 driver (tuner doesn't tune specific
 stations)
Message-Id: <20070725010621.d0c76468.akpm@linux-foundation.org>
In-Reply-To: <7b3edae10707240329q651e556eu53f064cf1b102bab@mail.gmail.com>
References: <7b3edae10707240329q651e556eu53f064cf1b102bab@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc v4l list)

On Tue, 24 Jul 2007 13:29:31 +0300 "Khelben Blackstaff" <eye.of.the.8eholder@gmail.com> wrote:

> Hello.
> 
> I have a "Terratec Cinergy HT PCI" tuner which works perfectly with
> 2.6.21 kernel.
> With 2.6.22 kernel it doesn't tune specific stations while it tunes
> others fine.
> I browsed the lkml from 13/05 (date the 2.6.22-rc1 was released) but
> haven't found
> anything similar nor in google. I have also tried 2.6.23-rc1 to see if
> its fixed.
> 
> lspci output:
> 01:0a.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> Video Broadcast Decoder (rev d1)
> lspci -n output:
> 01:0a.0 0480: 1131:7133 (rev d1)
> 
> dmesg output (same for 2.6.21/22/23-rc1):
> saa7130/34: v4l2 driver version 0.2.14 loaded
> ACPI: PCI Interrupt 0000:01:0a.0[A] -> GSI 21 (level, low) -> IRQ 21
> saa7133[0]: found at 0000:01:0a.0, rev: 209, irq: 21, latency: 64,
> mmio: 0xcdcff800
> saa7133[0]: subsystem: 153b:1175, board: Terratec Cinergy HT PCI
> [card=108,autodetected]
> saa7133[0]: board init: gpio is 0
> saa7133[0]: i2c eeprom 00: 3b 15 75 11 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
> saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 06 ff 00 94 02 51 96 2b
> saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
> saa7133[0]: i2c eeprom 40: ff 21 00 c0 96 10 03 32 15 10 fd 79 44 9f c2 8f
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner 0-004b: chip found @ 0x96 (saa7133[0])
> tuner 0-004b: setting tuner address to 60
> tuner 0-004b: type set to tda8290+75a
> tuner 0-004b: setting tuner address to 60
> tuner 0-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xcdcff800 irq 21 registered as card -1
> 
> the .config was copied from 2.6.21 -> 2.6.22 -> 2.6.23-rc1 and no
> option regarding
> the media/video was changed.
> 
> the behaviour is the same with xdtv and tvtime programs.
> 
> I have the following channels stored:
> UHF 23, 24, 25, 26, 27, 39, 43, 51, 54, 62, 65
> 
> With 2.6.21 every station works fine.
> With 2.6.22+ i get the following behavior:
> 23, 25, 26, 39, 43, 51, 54 work fine while
> 24, 27, 62, 65 have sound but no video.
> 
> The channels that don't work aren't small channels with low signal
> quality, they have
> the same quality with those that work, so i guess its not something
> about antenna quality.
> 
> Has anyone the same problem ?
> If you need any more info, please tell me.
> 
> Please CC me.
> Thank you for your time.
