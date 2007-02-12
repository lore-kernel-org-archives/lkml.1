Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXBLTl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXBLTl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbXBLTl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:41:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15656 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965337AbXBLTlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:41:55 -0500
Date: Mon, 12 Feb 2007 11:37:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20: Rebuild after trivial patch rebuilds way too much
Message-Id: <20070212113751.753afd33.randy.dunlap@oracle.com>
In-Reply-To: <200702122037.45927.arvidjaar@mail.ru>
References: <200702122037.45927.arvidjaar@mail.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 20:37:35 +0300 Andrey Borzenkov wrote:

> Is not it too much fore a trivial two lines patch to a single file?
> 
> {pts/1}% stg import 
> ~/patch/Re_2_6_20_rc6_libata_PATA_ATAPI_CDROM_is_not_working.patch
> Importing 
> patch "Re_2_6_20_rc6_libata_PATA_ATAPI_CDROM_is_not_working.patch"... done
> Now at patch "Re_2_6_20_rc6_libata_PATA_ATAPI_CDROM_is_not_working.patch"
> {pts/1}% make -C ~/src/linux-git O=$HOME/build/linux-2.6.20
> make: Entering directory `/home/bor/src/linux-git'
>   Using /home/bor/src/linux-git as source for kernel
>   GEN     /home/bor/build/linux-2.6.20/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   HOSTCC  usr/gen_init_cpio
>   GEN     usr/initramfs_data.cpio.gz
>   AS      usr/initramfs_data.o
>   LD      usr/built-in.o
>   LDS     arch/i386/kernel/vsyscall.lds
>   AS      arch/i386/kernel/vsyscall-int80.o
>   AS      arch/i386/kernel/vsyscall-note.o
>   SYSCALL arch/i386/kernel/vsyscall-int80.so
>   AS      arch/i386/kernel/vsyscall-sysenter.o
>   SYSCALL arch/i386/kernel/vsyscall-sysenter.so
>   AS      arch/i386/kernel/vsyscall.o
>   SYSCALL arch/i386/kernel/vsyscall-syms.o
>   LD      arch/i386/kernel/built-in.o
>   AS      arch/i386/kernel/head.o
>   CC      arch/i386/kernel/init_task.o
>   LDS     arch/i386/kernel/vmlinux.lds
>   CC [M]  drivers/ata/libata-core.o
> /home/bor/src/linux-git/drivers/ata/libata-core.c: In 
> function ‘ata_pci_device_do_resume’:
> /home/bor/src/linux-git/drivers/ata/libata-core.c:6228: warning: ignoring 
> return value of ‘pci_enable_device’, declared with attribute 
> warn_unused_result
>   LD [M]  drivers/ata/libata.o
>   CONMK   drivers/char/consolemap_deftbl.c
>   CC      drivers/char/consolemap_deftbl.o
>   SHIPPED drivers/char/defkeymap.c
>   CC      drivers/char/defkeymap.o
>   LD      drivers/char/built-in.o
>   HOSTCC  drivers/md/mktables
>   TABLE   drivers/md/raid6tables.c
>   CC [M]  drivers/md/raid6tables.o
>   UNROLL  drivers/md/raid6int1.c
>   CC [M]  drivers/md/raid6int1.o
>   UNROLL  drivers/md/raid6int2.c
>   CC [M]  drivers/md/raid6int2.o
>   UNROLL  drivers/md/raid6int4.c
>   CC [M]  drivers/md/raid6int4.o
>   UNROLL  drivers/md/raid6int8.c
>   CC [M]  drivers/md/raid6int8.o
>   UNROLL  drivers/md/raid6int16.c
>   CC [M]  drivers/md/raid6int16.o
>   UNROLL  drivers/md/raid6int32.c
>   CC [M]  drivers/md/raid6int32.o
>   UNROLL  drivers/md/raid6altivec1.c
>   CC [M]  drivers/md/raid6altivec1.o
>   UNROLL  drivers/md/raid6altivec2.c
>   CC [M]  drivers/md/raid6altivec2.o
>   UNROLL  drivers/md/raid6altivec4.c
>   CC [M]  drivers/md/raid6altivec4.o
>   UNROLL  drivers/md/raid6altivec8.c
>   CC [M]  drivers/md/raid6altivec8.o
>   LD [M]  drivers/md/raid456.o
>   LD [M]  drivers/md/md-mod.o
>   LD [M]  drivers/md/dm-mod.o
>   LD [M]  drivers/md/dm-multipath.o
>   LD [M]  drivers/md/dm-snapshot.o
>   LD [M]  drivers/md/dm-mirror.o
>   CC      drivers/video/logo/logo.o
>   LOGO    drivers/video/logo/logo_linux_mono.c
>   CC      drivers/video/logo/logo_linux_mono.o
>   LOGO    drivers/video/logo/logo_linux_vga16.c
>   CC      drivers/video/logo/logo_linux_vga16.o
>   LOGO    drivers/video/logo/logo_linux_clut224.c
>   CC      drivers/video/logo/logo_linux_clut224.o
>   LD      drivers/video/logo/built-in.o
>   LOGO    drivers/video/logo/logo_superh_mono.c
>   LOGO    drivers/video/logo/clut_vga16.c
>   LOGO    drivers/video/logo/logo_superh_vga16.c
>   LOGO    drivers/video/logo/logo_dec_clut224.c
>   LOGO    drivers/video/logo/logo_m32r_clut224.c
>   LOGO    drivers/video/logo/logo_mac_clut224.c
>   LOGO    drivers/video/logo/logo_parisc_clut224.c
>   LOGO    drivers/video/logo/logo_sgi_clut224.c
>   LOGO    drivers/video/logo/logo_sun_clut224.c
>   LOGO    drivers/video/logo/logo_superh_clut224.c
>   LD      drivers/video/built-in.o
>   LD      drivers/built-in.o
>   HOSTCC  lib/gen_crc32table
>   GEN     lib/crc32table.h
>   CC      lib/crc32.o
>   LD      lib/built-in.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
>   KSYM    .tmp_kallsyms1.S
>   AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      .tmp_vmlinux3
>   KSYM    .tmp_kallsyms3.S
>   AS      .tmp_kallsyms3.o
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
>   MODPOST vmlinux
>   AS      arch/i386/boot/bootsect.o
>   LD      arch/i386/boot/bootsect
>   AS      arch/i386/boot/setup.o
>   LD      arch/i386/boot/setup
>   AS      arch/i386/boot/compressed/head.o
>   CC      arch/i386/boot/compressed/misc.o
>   OBJCOPY arch/i386/boot/compressed/vmlinux.bin
>   GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
>   LD      arch/i386/boot/compressed/piggy.o
>   LD      arch/i386/boot/compressed/vmlinux
>   OBJCOPY arch/i386/boot/vmlinux.bin
>   HOSTCC  arch/i386/boot/tools/build
>   BUILD   arch/i386/boot/bzImage
> Root device is (8, 2)
> Boot sector 512 bytes.
> Setup is 7247 bytes.
> System is 1334 kB
> Kernel: arch/i386/boot/bzImage is ready  (#15)
>   Building modules, stage 2.
>   MODPOST 435 modules
>   CC      drivers/ata/libata.mod.o
>   LD [M]  drivers/ata/libata.ko
>   LD [M]  drivers/md/dm-mirror.ko
>   LD [M]  drivers/md/dm-mod.ko
>   LD [M]  drivers/md/dm-multipath.ko
>   LD [M]  drivers/md/dm-snapshot.ko
>   LD [M]  drivers/md/md-mod.ko
>   LD [M]  drivers/md/raid456.ko
> make: Leaving directory `/home/bor/src/linux-git'

Bummer.  It works as expected (as it should) for me.
Only libata is rebuilt.

I don't know stgit.  Are you sure that is the only patch that you applied?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
