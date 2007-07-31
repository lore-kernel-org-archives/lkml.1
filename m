Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbXGaXg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbXGaXg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXGaXgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:36:17 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:44541 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752782AbXGaXgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:36:16 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 19:36:15 EDT
Message-ID: <46AFC017.8090805@interia.pl>
Date: Wed, 01 Aug 2007 01:04:55 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Jaroslav Kysela <perex@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: CS5530 Alsa driver fails
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: f64f6acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linux: 2.6.23-rc1-git3
Hardware: CX5530

After "modprobe snd-cs5530" I have:
CS5530: XpressAudio at 0x220
CS5530: MPU at 0x330
CS5530: IRQ: 9 DMA8: 0 DMA16: 5
sb: can't grab irq 9
CS5530: Could not create SoundBlaster
CS5530_Audio: probe of 0000:00:12.3 failed with error -16

Thank You
Rafa³

~ $ cat /proc/interrupts
           CPU0
  0:      26624    XT-PIC-XT        timer
  2:          0    XT-PIC-XT        cascade
  4:        428    XT-PIC-XT        serial
  8:          0    XT-PIC-XT        rtc
  9:      10793    XT-PIC-XT        ohci_hcd:usb1
 10:       1326    XT-PIC-XT        eth0
NMI:          0
ERR:          0

~ $ lspci -v
00:00.0 Host bridge: Cyrix Corporation PCI Master
        Flags: bus master, medium devsel, latency 0

00:0f.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
        Subsystem: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
        Flags: bus master, medium devsel, latency 64, IRQ 10
        I/O ports at f800 [size=256]
        Memory at 10010000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at 10000000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2

00:12.0 ISA bridge: Cyrix Corporation 5530 Legacy [Kahlua]
        Flags: bus master, medium devsel, latency 0

00:12.1 Bridge: Cyrix Corporation 5530 SMI [Kahlua]
        Flags: medium devsel
        Memory at 40012000 (32-bit, non-prefetchable) [size=256]

00:12.2 IDE interface: Cyrix Corporation 5530 IDE [Kahlua] (prog-if 80 [Master])
        Flags: medium devsel
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        I/O ports at 1000 [disabled] [size=128]

00:12.3 Multimedia audio controller: Cyrix Corporation 5530 Audio [Kahlua]
        Flags: medium devsel
        Memory at 40011000 (32-bit, non-prefetchable) [size=128]

00:12.4 VGA compatible controller: Cyrix Corporation 5530 Video [Kahlua] (prog-if 00 [VGA])
        Flags: medium devsel
        Memory at 40010000 (32-bit, non-prefetchable) [size=4K]

00:13.0 USB Controller: Compaq Computer Corporation ZFMicro Chipset USB (rev 06) (prog-if 10 [OHCI])
        Subsystem: Compaq Computer Corporation ZFMicro Chipset USB
        Flags: bus master, medium devsel, latency 64, IRQ 9
        Memory at 000cc000 (32-bit, non-prefetchable) [size=4K]


----------------------------------------------------------------------
Kobiety klamia o wiele skuteczniej niz mezczyzni.
Sprawdz, jak sie na nich poznac

>>>http://link.interia.pl/f1b16

