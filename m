Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXC2OQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXC2OQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 10:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXC2OQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 10:16:17 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:34273 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbXC2OQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 10:16:16 -0400
X-Greylist: delayed 2665 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 10:16:15 EDT
Date: Thu, 29 Mar 2007 15:30:04 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix file specification in comments
Message-ID: <20070329133004.GA3606@cepheus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14+cvs20070321 (2007-03-20)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many files include the filename at the beginning, serveral used a wrong one.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
---
This is a follow up to f30c2269544bffc7bf1b0d7c0abe5be1be83b8cb.

This patch was generated with the same program as the former patch.

 arch/arm/mach-s3c2410/sleep.S                     |    2 +-
 arch/arm/plat-s3c24xx/sleep.S                     |    2 +-
 arch/i386/kernel/cpu/mcheck/therm_throt.c         |    2 +-
 arch/powerpc/platforms/8xx/mpc86xads_setup.c      |    2 +-
 arch/powerpc/platforms/8xx/mpc885ads_setup.c      |    2 +-
 arch/ppc/platforms/mpc866ads_setup.c              |    2 +-
 arch/ppc/syslib/ipic.c                            |    2 +-
 arch/sh/boards/se/7751/setup.c                    |    2 +-
 arch/sh/kernel/cpu/sh3/entry.S                    |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh73180.c           |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c            |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7770.c            |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c            |    2 +-
 arch/sh/kernel/vsyscall/vsyscall.c                |    2 +-
 arch/um/include/sysdep-i386/archsetjmp.h          |    2 +-
 arch/um/include/sysdep-x86_64/archsetjmp.h        |    2 +-
 arch/xtensa/kernel/pci-dma.c                      |    2 +-
 drivers/leds/leds-h1940.c                         |    2 +-
 drivers/video/console/softcursor.c                |    2 +-
 fs/jbd/checkpoint.c                               |    2 +-
 fs/jbd/recovery.c                                 |    2 +-
 fs/jbd/revoke.c                                   |    2 +-
 fs/jbd/transaction.c                              |    2 +-
 fs/jbd2/checkpoint.c                              |    2 +-
 fs/jbd2/recovery.c                                |    2 +-
 fs/jbd2/revoke.c                                  |    2 +-
 fs/jbd2/transaction.c                             |    2 +-
 include/asm-arm/arch-iop32x/glantank.h            |    2 +-
 include/asm-arm/arch-iop32x/n2100.h               |    2 +-
 include/asm-arm/arch-s3c2410/regs-power.h         |    2 +-
 include/asm-arm/arch-s3c2410/regs-s3c2443-clock.h |    2 +-
 include/asm-arm/arch-s3c2410/regs-watchdog.h      |    2 +-
 include/asm-arm/arch-s3c2410/udc.h                |    2 +-
 include/asm-sh/edosk7705.h                        |    2 +-
 include/asm-sh/snapgear.h                         |    2 +-
 include/asm-xtensa/platform-iss/simcall.h         |    2 +-
 include/linux/generic_acl.h                       |    2 +-
 sound/soc/pxa/pxa2xx-ac97.h                       |    2 +-
 sound/soc/pxa/pxa2xx-i2s.h                        |    2 +-
 39 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/arm/mach-s3c2410/sleep.S b/arch/arm/mach-s3c2410/sleep.S
index 637aaba..d1eeed2 100644
--- a/arch/arm/mach-s3c2410/sleep.S
+++ b/arch/arm/mach-s3c2410/sleep.S
@@ -1,4 +1,4 @@
-/* linux/arch/arm/mach-s3c2410/s3c2410-sleep.S
+/* linux/arch/arm/mach-s3c2410/sleep.S
  *
  * Copyright (c) 2004 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
diff --git a/arch/arm/plat-s3c24xx/sleep.S b/arch/arm/plat-s3c24xx/sleep.S
index 435349d..7b7ae79 100644
--- a/arch/arm/plat-s3c24xx/sleep.S
+++ b/arch/arm/plat-s3c24xx/sleep.S
@@ -1,4 +1,4 @@
-/* linux/arch/arm/mach-s3c2410/sleep.S
+/* linux/arch/arm/plat-s3c24xx/sleep.S
  *
  * Copyright (c) 2004 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c b/arch/i386/kernel/cpu/mcheck/therm_throt.c
index 065005c..2f28540 100644
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/i386/kerne/cpu/mcheck/therm_throt.c
+ * linux/arch/i386/kernel/cpu/mcheck/therm_throt.c
  *
  * Thermal throttle event support code (such as syslog messaging and rate
  * limiting) that was factored out from x86_64 (mce_intel.c) and i386 (p4.c).
diff --git a/arch/powerpc/platforms/8xx/mpc86xads_setup.c b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
index ef52ce7..652b665 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -1,4 +1,4 @@
-/*arch/ppc/platforms/mpc86xads-setup.c
+/*arch/powerpc/platforms/8xx/mpc86xads_setup.c
  *
  * Platform setup for the Freescale mpc86xads board
  *
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index c5fefdf..42aef56 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -1,4 +1,4 @@
-/*arch/ppc/platforms/mpc885ads-setup.c
+/*arch/powerpc/platforms/8xx/mpc885ads_setup.c
  *
  * Platform setup for the Freescale mpc885ads board
  *
diff --git a/arch/ppc/platforms/mpc866ads_setup.c b/arch/ppc/platforms/mpc866ads_setup.c
index 5b05d4b..2542a42 100644
--- a/arch/ppc/platforms/mpc866ads_setup.c
+++ b/arch/ppc/platforms/mpc866ads_setup.c
@@ -1,4 +1,4 @@
-/*arch/ppc/platforms/mpc866ads-setup.c
+/*arch/ppc/platforms/mpc866ads_setup.c
  *
  * Platform setup for the Freescale mpc866ads board
  *
diff --git a/arch/ppc/syslib/ipic.c b/arch/ppc/syslib/ipic.c
index 10659c2..9192777 100644
--- a/arch/ppc/syslib/ipic.c
+++ b/arch/ppc/syslib/ipic.c
@@ -1,5 +1,5 @@
 /*
- * include/asm-ppc/ipic.c
+ * arch/ppc/syslib/ipic.c
  *
  * IPIC routines implementations.
  *
diff --git a/arch/sh/boards/se/7751/setup.c b/arch/sh/boards/se/7751/setup.c
index e3feae6..4a2a918 100644
--- a/arch/sh/boards/se/7751/setup.c
+++ b/arch/sh/boards/se/7751/setup.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/sh/kernel/setup_7751se.c
+ * linux/arch/sh/boards/se/7751/setup.c
  *
  * Copyright (C) 2000  Kazumoto Kojima
  *
diff --git a/arch/sh/kernel/cpu/sh3/entry.S b/arch/sh/kernel/cpu/sh3/entry.S
index f3e827f..832c0b4 100644
--- a/arch/sh/kernel/cpu/sh3/entry.S
+++ b/arch/sh/kernel/cpu/sh3/entry.S
@@ -1,5 +1,5 @@
 /*
- * arch/sh/kernel/entry.S
+ * arch/sh/kernel/cpu/sh3/entry.S
  *
  *  Copyright (C) 1999, 2000, 2002  Niibe Yutaka
  *  Copyright (C) 2003 - 2006  Paul Mundt
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh73180.c b/arch/sh/kernel/cpu/sh4a/clock-sh73180.c
index 2fa5cb2..6d5ba37 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh73180.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh73180.c
@@ -1,5 +1,5 @@
 /*
- * arch/sh/kernel/cpu/sh4/clock-sh73180.c
+ * arch/sh/kernel/cpu/sh4a/clock-sh73180.c
  *
  * SH73180 support for the clock framework
  *
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7343.c b/arch/sh/kernel/cpu/sh4a/clock-sh7343.c
index 1707a21..7adc4f1 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7343.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7343.c
@@ -1,5 +1,5 @@
 /*
- * arch/sh/kernel/cpu/sh4/clock-sh7343.c
+ * arch/sh/kernel/cpu/sh4a/clock-sh7343.c
  *
  * SH7343/SH7722 support for the clock framework
  *
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7770.c b/arch/sh/kernel/cpu/sh4a/clock-sh7770.c
index c8694ba..8e23606 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7770.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7770.c
@@ -1,5 +1,5 @@
 /*
- * arch/sh/kernel/cpu/sh4/clock-sh7770.c
+ * arch/sh/kernel/cpu/sh4a/clock-sh7770.c
  *
  * SH7770 support for the clock framework
  *
diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7780.c b/arch/sh/kernel/cpu/sh4a/clock-sh7780.c
index 9e6a216..01f3da6 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7780.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7780.c
@@ -1,5 +1,5 @@
 /*
- * arch/sh/kernel/cpu/sh4/clock-sh7780.c
+ * arch/sh/kernel/cpu/sh4a/clock-sh7780.c
  *
  * SH7780 support for the clock framework
  *
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 7b0f66f..e146baf 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -1,5 +1,5 @@
 /*
- * arch/sh/kernel/vsyscall.c
+ * arch/sh/kernel/vsyscall/vsyscall.c
  *
  *  Copyright (C) 2006 Paul Mundt
  *
diff --git a/arch/um/include/sysdep-i386/archsetjmp.h b/arch/um/include/sysdep-i386/archsetjmp.h
index 11bafab..0f31208 100644
--- a/arch/um/include/sysdep-i386/archsetjmp.h
+++ b/arch/um/include/sysdep-i386/archsetjmp.h
@@ -1,5 +1,5 @@
 /*
- * arch/i386/include/klibc/archsetjmp.h
+ * arch/um/include/sysdep-i386/archsetjmp.h
  */
 
 #ifndef _KLIBC_ARCHSETJMP_H
diff --git a/arch/um/include/sysdep-x86_64/archsetjmp.h b/arch/um/include/sysdep-x86_64/archsetjmp.h
index 9a5e1a6..2af8f12 100644
--- a/arch/um/include/sysdep-x86_64/archsetjmp.h
+++ b/arch/um/include/sysdep-x86_64/archsetjmp.h
@@ -1,5 +1,5 @@
 /*
- * arch/x86_64/include/klibc/archsetjmp.h
+ * arch/um/include/sysdep-x86_64/archsetjmp.h
  */
 
 #ifndef _KLIBC_ARCHSETJMP_H
diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index ca76f07..f5319d7 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -1,5 +1,5 @@
 /*
- * arch/xtensa/pci-dma.c
+ * arch/xtensa/kernel/pci-dma.c
  *
  * DMA coherent memory allocation.
  *
diff --git a/drivers/leds/leds-h1940.c b/drivers/leds/leds-h1940.c
index 1d49d2a..677c993 100644
--- a/drivers/leds/leds-h1940.c
+++ b/drivers/leds/leds-h1940.c
@@ -1,5 +1,5 @@
 /*
- * drivers/leds/h1940-leds.c
+ * drivers/leds/leds-h1940.c
  * Copyright (c) Arnaud Patard <arnaud.patard@rtp-net.org>
  *
  * This file is subject to the terms and conditions of the GNU General Public
diff --git a/drivers/video/console/softcursor.c b/drivers/video/console/softcursor.c
index f577bd8..03cfb7a 100644
--- a/drivers/video/console/softcursor.c
+++ b/drivers/video/console/softcursor.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/video/softcursor.c
+ * linux/drivers/video/console/softcursor.c
  *
  * Generic software cursor for frame buffer devices
  *
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 0208cc7..47552d4 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/checkpoint.c
+ * linux/fs/jbd/checkpoint.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1999
  *
diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 11563fe..2a5f4b8 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/recovery.c
+ * linux/fs/jbd/recovery.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1999
  *
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index d204ab3..bb88d86 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/revoke.c
+ * linux/fs/jbd/revoke.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 2000
  *
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index cceaf57..a8a6e9d 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/transaction.c
+ * linux/fs/jbd/transaction.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1998
  *
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 68039fa..3fccde7 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/checkpoint.c
+ * linux/fs/jbd2/checkpoint.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1999
  *
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 9f10aca..395c92a 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/recovery.c
+ * linux/fs/jbd2/recovery.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1999
  *
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index f506646..b944bfc 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/revoke.c
+ * linux/fs/jbd2/revoke.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 2000
  *
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 3a87001..0b44326 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/transaction.c
+ * linux/fs/jbd2/transaction.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 1998
  *
diff --git a/include/asm-arm/arch-iop32x/glantank.h b/include/asm-arm/arch-iop32x/glantank.h
index 3b06561..bf0665a 100644
--- a/include/asm-arm/arch-iop32x/glantank.h
+++ b/include/asm-arm/arch-iop32x/glantank.h
@@ -1,5 +1,5 @@
 /*
- * include/asm/arch-iop32x/glantank.h
+ * include/asm-arm/arch-iop32x/glantank.h
  *
  * IO-Data GLAN Tank board registers
  */
diff --git a/include/asm-arm/arch-iop32x/n2100.h b/include/asm-arm/arch-iop32x/n2100.h
index fed31a6..77a8af4 100644
--- a/include/asm-arm/arch-iop32x/n2100.h
+++ b/include/asm-arm/arch-iop32x/n2100.h
@@ -1,5 +1,5 @@
 /*
- * include/asm/arch-iop32x/n2100.h
+ * include/asm-arm/arch-iop32x/n2100.h
  *
  * Thecus N2100 board registers
  */
diff --git a/include/asm-arm/arch-s3c2410/regs-power.h b/include/asm-arm/arch-s3c2410/regs-power.h
index 6c319ea..94ff965 100644
--- a/include/asm-arm/arch-s3c2410/regs-power.h
+++ b/include/asm-arm/arch-s3c2410/regs-power.h
@@ -1,4 +1,4 @@
-/* linux/include/asm/arch-s3c2410/regs-power.h
+/* linux/include/asm-arm/arch-s3c2410/regs-power.h
  *
  * Copyright (c) 2003,2004,2005,2006 Simtec Electronics <linux@simtec.co.uk>
  *		      http://armlinux.simtec.co.uk/
diff --git a/include/asm-arm/arch-s3c2410/regs-s3c2443-clock.h b/include/asm-arm/arch-s3c2410/regs-s3c2443-clock.h
index ff0536d..cd9e265 100644
--- a/include/asm-arm/arch-s3c2410/regs-s3c2443-clock.h
+++ b/include/asm-arm/arch-s3c2410/regs-s3c2443-clock.h
@@ -1,4 +1,4 @@
-/* linux/include/asm-arm/arch-s3c2410/regs-clock.h
+/* linux/include/asm-arm/arch-s3c2410/regs-s3c2443-clock.h
  *
  * Copyright (c) 2007 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
diff --git a/include/asm-arm/arch-s3c2410/regs-watchdog.h b/include/asm-arm/arch-s3c2410/regs-watchdog.h
index f4fff44..a9c5d49 100644
--- a/include/asm-arm/arch-s3c2410/regs-watchdog.h
+++ b/include/asm-arm/arch-s3c2410/regs-watchdog.h
@@ -1,4 +1,4 @@
-/* linux/include/asm/arch-s3c2410/regs-watchdog.h
+/* linux/include/asm-arm/arch-s3c2410/regs-watchdog.h
  *
  * Copyright (c) 2003 Simtec Electronics <linux@simtec.co.uk>
  *		      http://www.simtec.co.uk/products/SWLINUX/
diff --git a/include/asm-arm/arch-s3c2410/udc.h b/include/asm-arm/arch-s3c2410/udc.h
index e59ec33..b8aa6cb 100644
--- a/include/asm-arm/arch-s3c2410/udc.h
+++ b/include/asm-arm/arch-s3c2410/udc.h
@@ -1,4 +1,4 @@
-/* linux/include/asm/arch-s3c2410/udc.h
+/* linux/include/asm-arm/arch-s3c2410/udc.h
  *
  * Copyright (c) 2005 Arnaud Patard <arnaud.patard@rtp-net.org>
  *
diff --git a/include/asm-sh/edosk7705.h b/include/asm-sh/edosk7705.h
index a1089a6..5bdc9d9 100644
--- a/include/asm-sh/edosk7705.h
+++ b/include/asm-sh/edosk7705.h
@@ -1,5 +1,5 @@
 /*
- * include/asm-sh/edosk7705/io.h
+ * include/asm-sh/edosk7705.h
  *
  * Modified version of io_se.h for the EDOSK7705 specific functions.
  *
diff --git a/include/asm-sh/snapgear.h b/include/asm-sh/snapgear.h
index 6b5e4dd..2d712e7 100644
--- a/include/asm-sh/snapgear.h
+++ b/include/asm-sh/snapgear.h
@@ -1,5 +1,5 @@
 /*
- * include/asm-sh/snapgear/io.h
+ * include/asm-sh/snapgear.h
  *
  * Modified version of io_se.h for the snapgear-specific functions.
  *
diff --git a/include/asm-xtensa/platform-iss/simcall.h b/include/asm-xtensa/platform-iss/simcall.h
index 6acb572..b7952c0 100644
--- a/include/asm-xtensa/platform-iss/simcall.h
+++ b/include/asm-xtensa/platform-iss/simcall.h
@@ -1,5 +1,5 @@
 /*
- * include/asm-xtensa/platform-iss/hardware.h
+ * include/asm-xtensa/platform-iss/simcall.h
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
diff --git a/include/linux/generic_acl.h b/include/linux/generic_acl.h
index 80764f4..886f5fa 100644
--- a/include/linux/generic_acl.h
+++ b/include/linux/generic_acl.h
@@ -1,5 +1,5 @@
 /*
- * fs/generic_acl.c
+ * include/linux/generic_acl.h
  *
  * (C) 2005 Andreas Gruenbacher <agruen@suse.de>
  *
diff --git a/sound/soc/pxa/pxa2xx-ac97.h b/sound/soc/pxa/pxa2xx-ac97.h
index 4c4b882..b8ccfee 100644
--- a/sound/soc/pxa/pxa2xx-ac97.h
+++ b/sound/soc/pxa/pxa2xx-ac97.h
@@ -1,5 +1,5 @@
 /*
- * linux/sound/arm/pxa2xx-ac97.h
+ * linux/sound/soc/pxa/pxa2xx-ac97.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/sound/soc/pxa/pxa2xx-i2s.h b/sound/soc/pxa/pxa2xx-i2s.h
index a2484f0..4435bd9 100644
--- a/sound/soc/pxa/pxa2xx-i2s.h
+++ b/sound/soc/pxa/pxa2xx-i2s.h
@@ -1,5 +1,5 @@
 /*
- * linux/sound/arm/pxa2xx-i2s.h
+ * linux/sound/soc/pxa/pxa2xx-i2s.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.5.0.2.260.g2eb065


-- 
Uwe Kleine-König

5 out of 4 people have trouble with fractions.
