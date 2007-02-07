Return-Path: <linux-kernel-owner+w=401wt.eu-S1161212AbXBGLT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161212AbXBGLT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161207AbXBGLT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:19:57 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:38320 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161215AbXBGLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:19:56 -0500
Date: Wed, 7 Feb 2007 12:19:53 +0100
From: Eduard Bloch <edi@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6.20 regression] No text console picture after X start
Message-ID: <20070207111953.GA4105@rotes76.wohnheim.uni-kl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have an ATI Radeon X800 GTO card [1], which works "well"[2] with
xserver-xorg-video-ati 6.6.3-2 (Debian Sid). However, after upgrading to
2.6.20, the console screen is no longer restored after switching the
virtual terminal to first console when X has been started once.
Apparently the keyboard input does work but the picture is frozen at the
last image seen in X and some colors become changed (like on wrong color
pallette mapping).

There was no such problem with 2.6.19.2. No VESA framebuffer is used,
just plain VGA 80x25 text mode. I can return to the X11 console and
continue the work there.

Eduard.

[1]
02:00.0 VGA compatible controller: ATI Technologies Inc R480 [Radeon X800 GTO (PCIE)] (prog-if 00 [VGA])
        Subsystem: PC Partner Limited Unknown device 1600
        Flags: bus master, fast devsel, latency 0, IRQ 3
        Memory at c8000000 (64-bit, prefetchable) [size=128M]
        Memory at d1000000 (64-bit, non-prefetchable) [size=64K]
        I/O ports at 9000 [size=256]
        [virtual] Expansion ROM at d0000000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint IRQ 0
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
        Capabilities: [100] Advanced Error Reporting

02:00.1 Display controller: ATI Technologies Inc R480 [Radeon X800 GTO (PCIE)] (Secondary)
        Subsystem: PC Partner Limited Unknown device 1601
        Flags: fast devsel
        Memory at d1010000 (64-bit, non-prefetchable) [disabled] [size=64K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Express Endpoint IRQ 0

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 47
model name      : AMD Athlon(tm) 64 Processor 3500+
stepping        : 0
cpu MHz         : 1000.000
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm
bogomips        : 2001.55
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


[2]
Well like: I need to disable the dri module in xorg.conf otherwise the
kernel locks up when X starts. This fun has began with 2.6.16 or 2.6.17
or so.

Eduard.

-- 
Naja, Garbage Collector eben. Holt den Müll sogar vom Himmel.
       (Heise Trollforum über Java in der Flugzeugsteuerung)
