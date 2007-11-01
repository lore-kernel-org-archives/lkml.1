Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbXKARjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbXKARjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbXKARjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:39:00 -0400
Received: from rwcrmhc11.comcast.net ([216.148.227.151]:61482 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbXKARi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:38:59 -0400
Subject: Issue building kernel driver
From: Chris Holvenstot <cholvenstot@comcast.net>
To: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 Nov 2007 12:39:06 -0500
Message-Id: <1193938746.7555.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Although it may not be popular with the crowd here, I do have a valid
reason to run Windows - and I accomidate this using the VirtualBox
product.  

Since I try to be slightly useful and build as many of the "test" kernel
images I can I end up rebuilding the VirtualBox kernel driver (open
source) on an almost daily basis.

I attempted to rebuild the driver today and got the following error
messages running 2.6.24-rc1-git9

<snip>

make -f scripts/Makefile.build obj=/tmp/vbox.0
  gcc -m32 -Wp,-MD,/tmp/vbox.0/linux/.SUPDrv-linux.o.d  -nostdinc
-isystem /usr/lib/gcc/i486-linux-gnu/4.1.3/include -D__KERNEL__
-Iinclude  -include include/linux/autoconf.h  -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -O2 -pipe -msoft-float -mregparm=3
-freg-struct-return -mpreferred-stack-boundary=2  -march=k8
-mtune=generic -ffreestanding -maccumulate-outgoing-args  make -f
scripts/Makefile.build obj=/tmp/vbox.0
  gcc -m32 -Wp,-MD,/tmp/vbox.0/linux/.SUPDrv-linux.o.d  -nostdinc
-isystem /usr/lib/gcc/i486-linux-gnu/4.1.3/include -D__KERNEL__
-Iinclude  -include include/linux/autoconf.h  -Wall -Wundef
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
-Werror-implicit-function-declaration -O2 -pipe -msoft-float -mregparm=3
-freg-struct-return -mpreferred-stack-boundary=2  -march=k8
-mtune=generic -ffreestanding -maccumulate-outgoing-args
-Iinclude/asm-x86/mach-default -fomit-frame-pointer -g
-fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign
-I/lib/modules/2.6.24-rc1-git9/build/include  -I/tmp/vbox.0/
-I/tmp/vbox.0/include -I/tmp/vbox.0/r0drv/linux -D__KERNEL__ -DMODULE
-DRT_OS_LINUX -DIN_RING0 -DIN_RT_R0 -DIN_SUP_R0 -DCONFIG_VBOXDRV_AS_MISC
-DRT_ARCH_X86 -DVBOX_WITHOUT_IDT_PATCHING -DUSE_NEW_OS_INTERFACE_FOR_MM
-DMODULE -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(SUPDrv_linux)"
-D"KBUILD_MODNAME=KBUILD_STR(vboxdrv)" -c
-o /tmp/vbox.0/linux/.tmp_SUPDrv-linux.o /tmp/vbox.0/linux/SUPDrv-linux.c
In file included from /tmp/vbox.0/include/iprt/types.h:72,
                 from /tmp/vbox.0/include/VBox/types.h:21,
                 from /tmp/vbox.0/SUPDRV.h:26,
                 from /tmp/vbox.0/linux/SUPDrv-linux.c:22:
include/linux/types.h:40: error: redefinition of typedef ‘uintptr_t’
/tmp/vbox.0/include/iprt/stdint.h:118: error: previous declaration of
‘uintptr_t’ was here
In file included from include/linux/thread_info.h:20,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from /tmp/vbox.0/SUPDRV.h:87,
                 from /tmp/vbox.0/linux/SUPDrv-linux.c:22:
include/linux/bitops.h:6:1: warning: "BIT" redefined
In file included from /tmp/vbox.0/include/VBox/cdefs.h:20,
                 from /tmp/vbox.0/SUPDRV.h:25,
                 from /tmp/vbox.0/linux/SUPDrv-linux.c:22:
/tmp/vbox.0/include/iprt/cdefs.h:1042:1: warning: this is the location
of the previous definition
make[2]: *** [/tmp/vbox.0/linux/SUPDrv-linux.o] Error 1
make[1]: *** [_module_/tmp/vbox.0] Error 2
make[1]: Leaving directory `/build/linux-2.6.24-rc1-git9'
make: *** [vboxdrv] Error 2
 -Iinclude/asm-x86/mach-default -fomit-frame-pointer -g
-fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign
-I/lib/modules/2.6.24-rc1-git9/build/include  -I/tmp/vbox.0/
-I/tmp/vbox.0/include -I/tmp/vbox.0/r0drv/linux -D__KERNEL__ -DMODULE
-DRT_OS_LINUX -DIN_RING0 -DIN_RT_R0 -DIN_SUP_R0 -DCONFIG_VBOXDRV_AS_MISC
-DRT_ARCH_X86 -DVBOX_WITHOUT_IDT_PATCHING -DUSE_NEW_OS_INTERFACE_FOR_MM
-DMODULE -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(SUPDrv_linux)"
-D"KBUILD_MODNAME=KBUILD_STR(vboxdrv)" -c
-o /tmp/vbox.0/linux/.tmp_SUPDrv-linux.o /tmp/vbox.0/linux/SUPDrv-linux.c
In file included from /tmp/vbox.0/include/iprt/types.h:72,
                 from /tmp/vbox.0/include/VBox/types.h:21,
                 from /tmp/vbox.0/SUPDRV.h:26,
                 from /tmp/vbox.0/linux/SUPDrv-linux.c:22:
include/linux/types.h:40: error: redefinition of typedef ‘uintptr_t’
/tmp/vbox.0/include/iprt/stdint.h:118: error: previous declaration of
‘uintptr_t’ was here
In file included from include/linux/thread_info.h:20,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from /tmp/vbox.0/SUPDRV.h:87,
                 from /tmp/vbox.0/linux/SUPDrv-linux.c:22:
include/linux/bitops.h:6:1: warning: "BIT" redefined
In file included from /tmp/vbox.0/include/VBox/cdefs.h:20,
                 from /tmp/vbox.0/SUPDRV.h:25,
                 from /tmp/vbox.0/linux/SUPDrv-linux.c:22:
/tmp/vbox.0/include/iprt/cdefs.h:1042:1: warning: this is the location
of the previous definition
make[2]: *** [/tmp/vbox.0/linux/SUPDrv-linux.o] Error 1
make[1]: *** [_module_/tmp/vbox.0] Error 2
make[1]: Leaving directory `/build/linux-2.6.24-rc1-git9'
make: *** [vboxdrv] Error 2

</snip>

I got the same error with 2.6.24-rc1-git10.  Building this driver works
under 2.6.24-rc1-git4 (unfortunately due to some issues with my SATA
drives I did not get the chance to build git5-git8)

I am not sure if this should be reported to the kernel folks or the
VirtualBox folks - but the kernel code is what changed.  However I will
post this on the VirtualBox forum too.

Thanks




