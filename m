Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbXKKGt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbXKKGt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 01:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbXKKGsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 01:48:51 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32860 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755939AbXKKGsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 01:48:50 -0500
Date: Sun, 11 Nov 2007 07:48:25 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove references to "make dep"
Message-ID: <20071111064825.GF21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"make dep" is no longer required in kernel 2.6, but was still mentioned 
in some places.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/arm/mach-imx/Makefile                 |    3 ---
 arch/arm/mach-netx/Makefile                |    3 ---
 arch/frv/kernel/gdb-stub.c                 |    2 +-
 arch/mips/tx4927/common/Makefile           |    4 ----
 arch/mips/tx4938/common/Makefile           |    4 ----
 arch/mips/tx4938/toshiba_rbtx4938/Makefile |    4 ----
 arch/sh64/kernel/Makefile                  |    4 ----
 arch/sh64/lib/Makefile                     |    4 ----
 arch/sh64/mach-cayman/Makefile             |    4 ----
 arch/sh64/mm/Makefile                      |    4 ----
 arch/xtensa/mm/Makefile                    |    4 ----
 arch/xtensa/platform-iss/Makefile          |    5 -----
 12 files changed, 1 insertion(+), 44 deletions(-)

b7a9343060fc2ea1cf40c731c3eb46bab1d38bae 
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index 02272aa..88d5e61 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -1,9 +1,6 @@
 #
 # Makefile for the linux kernel.
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
 
 # Object file lists.
 
diff --git a/arch/arm/mach-netx/Makefile b/arch/arm/mach-netx/Makefile
index 18785ff..7ce4ba9 100644
--- a/arch/arm/mach-netx/Makefile
+++ b/arch/arm/mach-netx/Makefile
@@ -1,9 +1,6 @@
 #
 # Makefile for the linux kernel.
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
 
 # Object file lists.
 
diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index e89cad1..48a0393 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -87,7 +87,7 @@
  *  Example:
  *    $ cd ~/linux
  *    $ make menuconfig <go to "Kernel Hacking" and turn on remote debugging>
- *    $ make dep; make vmlinux
+ *    $ make vmlinux
  *
  *  Step 3:
  *  Download the kernel to the remote target and start
diff --git a/arch/mips/tx4927/common/Makefile b/arch/mips/tx4927/common/Makefile
index 1837578..e862961 100644
--- a/arch/mips/tx4927/common/Makefile
+++ b/arch/mips/tx4927/common/Makefile
@@ -1,10 +1,6 @@
 #
 # Makefile for common code for Toshiba TX4927 based systems
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 obj-y	+= tx4927_prom.o tx4927_setup.o tx4927_irq.o
 
diff --git a/arch/mips/tx4938/common/Makefile b/arch/mips/tx4938/common/Makefile
index 8352eca..eff3d1d 100644
--- a/arch/mips/tx4938/common/Makefile
+++ b/arch/mips/tx4938/common/Makefile
@@ -1,10 +1,6 @@
 #
 # Makefile for common code for Toshiba TX4927 based systems
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 obj-y	+= prom.o setup.o irq.o
 obj-$(CONFIG_KGDB) += dbgio.o
diff --git a/arch/mips/tx4938/toshiba_rbtx4938/Makefile b/arch/mips/tx4938/toshiba_rbtx4938/Makefile
index 675bb1c..2316dd7 100644
--- a/arch/mips/tx4938/toshiba_rbtx4938/Makefile
+++ b/arch/mips/tx4938/toshiba_rbtx4938/Makefile
@@ -1,10 +1,6 @@
 #
 # Makefile for common code for Toshiba TX4927 based systems
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 obj-y	+= prom.o setup.o irq.o spi_eeprom.o
 
diff --git a/arch/sh64/kernel/Makefile b/arch/sh64/kernel/Makefile
index e3467bd..8443d3b 100644
--- a/arch/sh64/kernel/Makefile
+++ b/arch/sh64/kernel/Makefile
@@ -8,10 +8,6 @@
 #
 # Makefile for the Linux sh64 kernel.
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 extra-y	:= head.o init_task.o vmlinux.lds
 
diff --git a/arch/sh64/lib/Makefile b/arch/sh64/lib/Makefile
index 6a4cc3f..754d725 100644
--- a/arch/sh64/lib/Makefile
+++ b/arch/sh64/lib/Makefile
@@ -8,10 +8,6 @@
 #
 # Makefile for the SH-5 specific library files..
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 # Panic should really be compiled as PIC
 lib-y  := udelay.o c-checksum.o dbg.o io.o panic.o memcpy.o copy_user_memcpy.o \
diff --git a/arch/sh64/mach-cayman/Makefile b/arch/sh64/mach-cayman/Makefile
index 67a2258..847c828 100644
--- a/arch/sh64/mach-cayman/Makefile
+++ b/arch/sh64/mach-cayman/Makefile
@@ -1,10 +1,6 @@
 #
 # Makefile for the Hitachi Cayman specific parts of the kernel
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 obj-y := setup.o irq.o iomap.o
 obj-$(CONFIG_HEARTBEAT)	+= led.o
diff --git a/arch/sh64/mm/Makefile b/arch/sh64/mm/Makefile
index d0e8136..486c656 100644
--- a/arch/sh64/mm/Makefile
+++ b/arch/sh64/mm/Makefile
@@ -8,10 +8,6 @@
 #
 # Makefile for the sh64-specific parts of the Linux memory manager.
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 obj-y := cache.o consistent.o extable.o fault.o init.o ioremap.o \
 	 tlbmiss.o tlb.o
diff --git a/arch/xtensa/mm/Makefile b/arch/xtensa/mm/Makefile
index 10aec22..64e304a 100644
--- a/arch/xtensa/mm/Makefile
+++ b/arch/xtensa/mm/Makefile
@@ -1,9 +1,5 @@
 #
 # Makefile for the Linux/Xtensa-specific parts of the memory manager.
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
 
 obj-y	 := init.o fault.o tlb.o misc.o cache.o
diff --git a/arch/xtensa/platform-iss/Makefile b/arch/xtensa/platform-iss/Makefile
index 5b394e9..af96e31 100644
--- a/arch/xtensa/platform-iss/Makefile
+++ b/arch/xtensa/platform-iss/Makefile
@@ -3,11 +3,6 @@
 # Makefile for the Xtensa Instruction Set Simulator (ISS)
 # "prom monitor" library routines under Linux.
 #
-# Note! Dependencies are done automagically by 'make dep', which also
-# removes any old dependencies. DON'T put your own dependencies here
-# unless it's something special (ie not a .c file).
-#
-# Note 2! The CFLAGS definitions are in the main makefile...
 
 obj-y			= io.o console.o setup.o network.o
 

