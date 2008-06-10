Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYFJKid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYFJKid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYFJKiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:38:04 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42880 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYFJKiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:38:02 -0400
Date: Tue, 10 Jun 2008 12:38:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: modpost error message with -j builds
Message-ID: <20080610103843.GA1900@uranus.ravnborg.org>
References: <20080610102523.GB17556@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610102523.GB17556@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 01:25:23PM +0300, Adrian Bunk wrote:
> I just say the following with a -j 2 build:
> 
> <--  snip  -->
> 
> ...
>   CHECK   include/linux/version.h
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
>   Building modules, stage 2.
>   MODPOST 222 modules
>   CC      arch/x86/boot/a20.o
>   CC      arch/x86/boot/cmdline.o
>   AS      arch/x86/boot/copy.o
>   HOSTCC  arch/x86/boot/mkcpustr
>   CC      arch/x86/boot/cpucheck.o
>   CC      arch/x86/boot/edd.o
>   AS      arch/x86/boot/compressed/head_64.o
>   CC      arch/x86/boot/compressed/misc.o
> ERROR: "____ilog2_NaN" [drivers/usb/core/usbcore.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> make: *** Waiting for unfinished jobs....
>   CC      arch/x86/boot/main.o
>   CC      arch/x86/boot/mca.o
>   CC      arch/x86/boot/memory.o
>   CC      arch/x86/boot/pm.o
>   AS      arch/x86/boot/pmjump.o
>   CC      arch/x86/boot/printf.o
>   CC      arch/x86/boot/string.o
>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>   CC      arch/x86/boot/tty.o
>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>   CC      arch/x86/boot/video.o
>   CC      arch/x86/boot/video-mode.o
>   CC      arch/x86/boot/version.o
>   CC      arch/x86/boot/video-vga.o
>   CC      arch/x86/boot/video-vesa.o
>   CC      arch/x86/boot/video-bios.o
>   HOSTCC  arch/x86/boot/tools/build
>   CPUSTR  arch/x86/boot/cpustr.h
>   CC      arch/x86/boot/cpu.o
>   LD      arch/x86/boot/compressed/piggy.o
>   LD      arch/x86/boot/compressed/vmlinux
>   OFFSETS arch/x86/boot/offsets.h
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   AS      arch/x86/boot/header.o
>   LD      arch/x86/boot/setup.elf
>   OBJCOPY arch/x86/boot/setup.bin
>   BUILD   arch/x86/boot/bzImage
> Root device is (8, 1)
> Setup is 12252 bytes (padded to 12288 bytes).
> System is 2498 kB
> CRC ee7ee55
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> 
> <--  snip  -->
> 
> It would be good if there was a last line "ERROR: ..." when the build 
> finished with a non-zero return value.

Agree. But I do not know how to teach make to do so.
If anyone have some hints I'm interested.

	Sam
