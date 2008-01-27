Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbYA0SqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbYA0SqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYA0Spt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:45:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:40108 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbYA0Spr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:45:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=yGxF9dYWZ7OmZC+gdKyoMNxeJAOB8uWH8Cu7JKETlT+Rp7sMggnCQ6rATwqbPzaL63MV+ts4dSg55Dil10JqjkKsGasyV6xtgebFpeh+iDAqQO3ykhHC7OHIMrjGojaK1RzM7aKw2DL8hRfp7hFg2gMlpP8sH582OxuokwX2XYY=
Message-ID: <76366b180801271045u7342540p58f5970a49c097be@mail.gmail.com>
Date: Sun, 27 Jan 2008 13:45:45 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org, "Jordan Crouse" <jordan.crouse@amd.com>
Subject: lxfb is not changing modes, no errors/information printing out
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 0d4dffe346a775d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using 2.6.24, I can't get my Geode LX (LX800 CPU) to boot in anything
other than the default 80x25 console even though lxfb appears to be
loading normally. This device doesn't work with the VESA fb either
when I request "vga=0x31a". All the other boards I have display a
1280x1024 console on my monitor. Are my kernel parameters wrong in
some way? I tried "video=lxfb:<mode>" with and without "vga=0x31a".
The driver is compiled into the kernel -- I am not using modules.

Also, a side note.. blanking on this display doesn't seem to work
properly. When the screen would normally blank after a timeout, a thin
~20px width vertical black strip appears on the left-hand side of the
screen, but the rest of the display area remains showing whatever
contents were on the screen when the blank was triggered. Hitting a
key goes back to displaying the current fb contents like you would
expect.

Thanks,
-Andrew

Relevant dmesg info:

Kernel command line: video=lxfb:1280x1024-60 vga=0x31a root=/dev/hda1
Console: colour dummy device 80x25
console [tty0] enabled
lxfb 0000:00:01.1: 8192 KB of video memory at 0xee000000
Console: switching to colour frame buffer device 80x30
fb0: Geode LX frame buffer device

# lspci -vvnnxxxx -s 00:01.1
00:01.1 VGA compatible controller [0300]: Advanced Micro Devices [AMD]
Geode LX Video [1022:2081] (prog-if 00 [VGA])
        Subsystem: Advanced Micro Devices [AMD] Geode LX Video [1022:2081]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at ee000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at efff4000 (32-bit, non-prefetchable) [size=16K]
        Region 2: Memory at efff0000 (32-bit, non-prefetchable) [size=16K]
        Region 3: Memory at effec000 (32-bit, non-prefetchable) [size=16K]
        Region 4: Memory at effe8000 (32-bit, non-prefetchable) [size=16K]
00: 22 10 81 20 07 00 20 02 00 00 00 03 08 00 00 00
10: 00 00 00 ee 00 40 ff ef 00 00 ff ef 00 c0 fe ef
20: 00 80 fe ef 00 00 00 00 00 00 00 00 22 10 81 20
30: 00 00 00 00 00 00 00 00 00 00 00 00 07 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: d0 03 00 00 c0 03 00 00 00 00 0a 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

# grep CONFIG_FB.*=y .config
CONFIG_FB=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y

# cat /sys/class/graphics/fb0/name
Geode LX
# cat /sys/class/graphics/fb0/modes
U:640x480p-63
# cat /sys/class/graphics/fb0/state
0
# cat /sys/class/graphics/fb0/virtual_size
640,480
# cat /sys/class/graphics/fb0/stride
1280
