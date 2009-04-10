Return-Path: <linux-kernel-owner+w=401wt.eu-S936439AbZDJMak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936439AbZDJMak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbZDJMaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:30:30 -0400
Received: from bgo1smout1.broadpark.no ([217.13.4.94]:43550 "EHLO
	bgo1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZDJMa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:30:29 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2009 08:30:28 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Message-id: <49DF2DCE.5050102@bakke.com>
Date: Fri, 10 Apr 2009 13:30:22 +0200
From: Dag Bakke <dag@bakke.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
To: linux-kernel@vger.kernel.org
Subject: video (VGA) object-files unconditionally built/included?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I am putting together a tiny kernel for an embedded x86 target. Space is
tight, so I try to shave every kB I can get rid of.
I don't have anything resembling VGA or graphics, and my .config
reflects that. (Serial console.)

Yet, when building the kernel I see:

  LZMA    arch/x86/boot/compressed/vmlinux.bin.lzma
  CC      arch/x86/boot/video.o
  CC      arch/x86/boot/video-mode.o
  CC      arch/x86/boot/version.o
  CC      arch/x86/boot/video-vga.o
  CC      arch/x86/boot/video-vesa.o
  CC      arch/x86/boot/video-bios.o

# strings arch/x86/boot/bzImage | egrep -i 'vesa|vga|bios|mode'
+VESA
0123456789ABCDEFPress <ENTER> to see video modes available, <SPACE> to
continue, or wait 30 sec
Mode: Resolution:  Type:
Enter a video mode or "scan" to scan for additional modes:
Undefined video mode number: %x
VESA
BIOS


The video* objects sums up to 87kB. Can I get rid of that somehow? I am
using current git.

This is my .config:
http://tapas.homeip.net/~dagb/tiny.config

Cc: is appreciated.



Thanks,

Dag B

