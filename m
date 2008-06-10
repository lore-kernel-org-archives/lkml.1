Return-Path: <linux-kernel-owner+w=401wt.eu-S1760373AbYFJK0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373AbYFJK0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYFJK0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:26:22 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50200 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYFJK0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:26:20 -0400
Date: Tue, 10 Jun 2008 13:25:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: modpost error message with -j builds
Message-ID: <20080610102523.GB17556@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just say the following with a -j 2 build:

<--  snip  -->

...
  CHECK   include/linux/version.h
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  Building modules, stage 2.
  MODPOST 222 modules
  CC      arch/x86/boot/a20.o
  CC      arch/x86/boot/cmdline.o
  AS      arch/x86/boot/copy.o
  HOSTCC  arch/x86/boot/mkcpustr
  CC      arch/x86/boot/cpucheck.o
  CC      arch/x86/boot/edd.o
  AS      arch/x86/boot/compressed/head_64.o
  CC      arch/x86/boot/compressed/misc.o
ERROR: "____ilog2_NaN" [drivers/usb/core/usbcore.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....
  CC      arch/x86/boot/main.o
  CC      arch/x86/boot/mca.o
  CC      arch/x86/boot/memory.o
  CC      arch/x86/boot/pm.o
  AS      arch/x86/boot/pmjump.o
  CC      arch/x86/boot/printf.o
  CC      arch/x86/boot/string.o
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
  CC      arch/x86/boot/tty.o
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
  CC      arch/x86/boot/video.o
  CC      arch/x86/boot/video-mode.o
  CC      arch/x86/boot/version.o
  CC      arch/x86/boot/video-vga.o
  CC      arch/x86/boot/video-vesa.o
  CC      arch/x86/boot/video-bios.o
  HOSTCC  arch/x86/boot/tools/build
  CPUSTR  arch/x86/boot/cpustr.h
  CC      arch/x86/boot/cpu.o
  LD      arch/x86/boot/compressed/piggy.o
  LD      arch/x86/boot/compressed/vmlinux
  OFFSETS arch/x86/boot/offsets.h
  OBJCOPY arch/x86/boot/vmlinux.bin
  AS      arch/x86/boot/header.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  BUILD   arch/x86/boot/bzImage
Root device is (8, 1)
Setup is 12252 bytes (padded to 12288 bytes).
System is 2498 kB
CRC ee7ee55
Kernel: arch/x86/boot/bzImage is ready  (#1)

<--  snip  -->

It would be good if there was a last line "ERROR: ..." when the build 
finished with a non-zero return value.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

