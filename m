Return-Path: <linux-kernel-owner+w=401wt.eu-S1422726AbXDXQdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbXDXQdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 12:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422744AbXDXQdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 12:33:17 -0400
Received: from mta9.adelphia.net ([68.168.78.199]:47611 "EHLO
	mta9.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422726AbXDXQdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 12:33:16 -0400
Date: Tue, 24 Apr 2007 11:33:13 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove unnecessary include of linux/tty.h from a bunch of files
Message-ID: <20070424163313.GA30564@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Remove unnecessary include of linux/tty.h from a bunch of files

Including serial_core.h no longer requires including tty.h first, but
a lot of files still seem to have this in them.  Remove all the
unnecessary references.

Signed-off-by: Corey Minyard <minyard@acm.org>


Index: linux-2.6.21-rc7/arch/arm/mach-ep93xx/core.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ep93xx/core.c
+++ linux-2.6.21-rc7/arch/arm/mach-ep93xx/core.c
@@ -19,7 +19,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
Index: linux-2.6.21-rc7/arch/arm/mach-ixp2000/enp2611.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ixp2000/enp2611.c
+++ linux-2.6.21-rc7/arch/arm/mach-ixp2000/enp2611.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 
Index: linux-2.6.21-rc7/arch/arm/mach-ixp2000/ixdp2x01.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ixp2000/ixdp2x01.c
+++ linux-2.6.21-rc7/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
Index: linux-2.6.21-rc7/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ixp23xx/core.c
+++ linux-2.6.21-rc7/arch/arm/mach-ixp23xx/core.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
Index: linux-2.6.21-rc7/arch/arm/mach-ixp23xx/espresso.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ixp23xx/espresso.c
+++ linux-2.6.21-rc7/arch/arm/mach-ixp23xx/espresso.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/serial.h>
Index: linux-2.6.21-rc7/arch/arm/mach-ixp23xx/ixdp2351.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ixp23xx/ixdp2351.c
+++ linux-2.6.21-rc7/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/serial.h>
Index: linux-2.6.21-rc7/arch/arm/mach-ixp23xx/roadrunner.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ixp23xx/roadrunner.c
+++ linux-2.6.21-rc7/arch/arm/mach-ixp23xx/roadrunner.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/serial.h>
Index: linux-2.6.21-rc7/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6.21-rc7/arch/arm/mach-ixp4xx/common.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/serial.h>
 #include <linux/sched.h>
-#include <linux/tty.h>
 #include <linux/platform_device.h>
 #include <linux/serial_core.h>
 #include <linux/bootmem.h>
Index: linux-2.6.21-rc7/arch/arm/mach-sa1100/h3600.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-sa1100/h3600.c
+++ linux-2.6.21-rc7/arch/arm/mach-sa1100/h3600.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/tty.h>
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/mtd/mtd.h>
Index: linux-2.6.21-rc7/arch/arm/mach-sa1100/hackkit.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-sa1100/hackkit.c
+++ linux-2.6.21-rc7/arch/arm/mach-sa1100/hackkit.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/tty.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/cpufreq.h>
Index: linux-2.6.21-rc7/arch/arm/mach-sa1100/neponset.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-sa1100/neponset.c
+++ linux-2.6.21-rc7/arch/arm/mach-sa1100/neponset.c
@@ -5,7 +5,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/ptrace.h>
-#include <linux/tty.h>
 #include <linux/ioport.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
Index: linux-2.6.21-rc7/arch/arm/mach-sa1100/simpad.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/mach-sa1100/simpad.c
+++ linux-2.6.21-rc7/arch/arm/mach-sa1100/simpad.c
@@ -5,7 +5,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/string.h> 
 #include <linux/pm.h>
Index: linux-2.6.21-rc7/arch/arm/plat-iop/i2c.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/arm/plat-iop/i2c.c
+++ linux-2.6.21-rc7/arch/arm/plat-iop/i2c.c
@@ -16,7 +16,6 @@
 #include <linux/fs.h>
 #include <linux/platform_device.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
Index: linux-2.6.21-rc7/arch/mips/basler/excite/excite_setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/basler/excite/excite_setup.c
+++ linux-2.6.21-rc7/arch/mips/basler/excite/excite_setup.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/ioport.h>
Index: linux-2.6.21-rc7/arch/mips/gt64120/wrppmc/setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/gt64120/wrppmc/setup.c
+++ linux-2.6.21-rc7/arch/mips/gt64120/wrppmc/setup.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/pm.h>
Index: linux-2.6.21-rc7/arch/mips/jmr3927/rbhma3100/setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/jmr3927/rbhma3100/setup.c
+++ linux-2.6.21-rc7/arch/mips/jmr3927/rbhma3100/setup.c
@@ -47,7 +47,6 @@
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #ifdef CONFIG_SERIAL_TXX9
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #endif
Index: linux-2.6.21-rc7/arch/mips/lasat/setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/lasat/setup.c
+++ linux-2.6.21-rc7/arch/mips/lasat/setup.c
@@ -26,7 +26,6 @@
 #include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/mips/mips-boards/atlas/atlas_setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/mips-boards/atlas/atlas_setup.c
+++ linux-2.6.21-rc7/arch/mips/mips-boards/atlas/atlas_setup.c
@@ -19,7 +19,6 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/ioport.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/mips/mips-boards/sead/sead_setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/mips-boards/sead/sead_setup.c
+++ linux-2.6.21-rc7/arch/mips/mips-boards/sead/sead_setup.c
@@ -20,7 +20,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/ioport.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/mips/mips-boards/sim/sim_setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/mips-boards/sim/sim_setup.c
+++ linux-2.6.21-rc7/arch/mips/mips-boards/sim/sim_setup.c
@@ -20,7 +20,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/mips/momentum/jaguar_atx/ja-console.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/momentum/jaguar_atx/ja-console.c
+++ linux-2.6.21-rc7/arch/mips/momentum/jaguar_atx/ja-console.c
@@ -11,7 +11,6 @@
 #include <linux/major.h>
 #include <linux/termios.h>
 #include <linux/sched.h>
-#include <linux/tty.h>
 
 #include <linux/serial.h>
 #include <linux/serial_core.h>
Index: linux-2.6.21-rc7/arch/mips/pmc-sierra/yosemite/py-console.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/pmc-sierra/yosemite/py-console.c
+++ linux-2.6.21-rc7/arch/mips/pmc-sierra/yosemite/py-console.c
@@ -11,7 +11,6 @@
 #include <linux/major.h>
 #include <linux/termios.h>
 #include <linux/sched.h>
-#include <linux/tty.h>
 
 #include <linux/serial.h>
 #include <linux/serial_core.h>
Index: linux-2.6.21-rc7/arch/mips/pmc-sierra/yosemite/setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/pmc-sierra/yosemite/setup.c
+++ linux-2.6.21-rc7/arch/mips/pmc-sierra/yosemite/setup.c
@@ -36,7 +36,6 @@
 #include <linux/interrupt.h>
 #include <linux/timex.h>
 #include <linux/termios.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/mips/sgi-ip32/ip32-setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/sgi-ip32/ip32-setup.c
+++ linux-2.6.21-rc7/arch/mips/sgi-ip32/ip32-setup.c
@@ -63,7 +63,6 @@ static inline void str2eaddr(unsigned ch
 #endif
 
 #ifdef CONFIG_SERIAL_8250
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #endif /* CONFIG_SERIAL_8250 */
Index: linux-2.6.21-rc7/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
+++ linux-2.6.21-rc7/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -77,7 +77,6 @@
 #include <linux/ide.h>
 #endif
 #ifdef CONFIG_SERIAL_TXX9
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #endif
Index: linux-2.6.21-rc7/arch/mips/tx4938/toshiba_rbtx4938/setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/mips/tx4938/toshiba_rbtx4938/setup.c
+++ linux-2.6.21-rc7/arch/mips/tx4938/toshiba_rbtx4938/setup.c
@@ -30,7 +30,6 @@
 #include <asm/bootinfo.h>
 #include <asm/tx4938/rbtx4938.h>
 #ifdef CONFIG_SERIAL_TXX9
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #endif
Index: linux-2.6.21-rc7/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ linux-2.6.21-rc7/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -29,7 +29,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 
 #include <asm/system.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/bamboo.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/bamboo.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/bamboo.c
@@ -26,7 +26,6 @@
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/ethtool.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/bubinga.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/bubinga.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/bubinga.c
@@ -18,7 +18,6 @@
 #include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/rtc.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/ebony.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/ebony.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/ebony.c
@@ -29,7 +29,6 @@
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/luan.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/luan.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/luan.c
@@ -27,7 +27,6 @@
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/ocotea.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/ocotea.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/ocotea.c
@@ -27,7 +27,6 @@
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/xilinx_ml300.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/xilinx_ml300.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/xilinx_ml300.c
@@ -11,7 +11,6 @@
 
 #include <linux/init.h>
 #include <linux/irq.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/xilinx_ml403.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/xilinx_ml403.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/xilinx_ml403.c
@@ -15,7 +15,6 @@
 
 #include <linux/init.h>
 #include <linux/irq.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/yucca.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/yucca.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/yucca.c
@@ -28,7 +28,6 @@
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
Index: linux-2.6.21-rc7/arch/ppc/platforms/83xx/mpc834x_sys.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/83xx/mpc834x_sys.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/83xx/mpc834x_sys.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/85xx/mpc8540_ads.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/85xx/mpc8540_ads.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/85xx/mpc8540_ads.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/85xx/mpc8560_ads.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/85xx/mpc8560_ads.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/85xx/mpc8560_ads.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/85xx/mpc85xx_cds_common.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/85xx/mpc85xx_cds_common.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/85xx/mpc85xx_cds_common.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/root_dev.h>
 #include <linux/initrd.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/fsl_devices.h>
 
Index: linux-2.6.21-rc7/arch/ppc/platforms/85xx/sbc8560.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/85xx/sbc8560.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/85xx/sbc8560.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/85xx/tqm85xx.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/85xx/tqm85xx.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/85xx/tqm85xx.c
@@ -27,7 +27,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/ev64260.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/ev64260.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/ev64260.c
@@ -33,7 +33,6 @@
 #include <linux/platform_device.h>
 #if !defined(CONFIG_SERIAL_MPSC_CONSOLE)
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #else
 #include <linux/mv643xx.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/radstone_ppc7d.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/radstone_ppc7d.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/radstone_ppc7d.c
@@ -33,7 +33,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>		/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/mv643xx.h>
 #include <linux/netdevice.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/sandpoint.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/sandpoint.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/sandpoint.c
@@ -75,7 +75,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
 
Index: linux-2.6.21-rc7/arch/ppc/platforms/spruce.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/spruce.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/spruce.c
@@ -25,7 +25,6 @@
 #include <linux/ide.h>
 #include <linux/root_dev.h>
 #include <linux/serial.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 
 #include <asm/system.h>
Index: linux-2.6.21-rc7/arch/ppc/syslib/gen550_dbg.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/syslib/gen550_dbg.c
+++ linux-2.6.21-rc7/arch/ppc/syslib/gen550_dbg.c
@@ -16,7 +16,6 @@
 
 #include <linux/types.h>
 #include <linux/serial.h>
-#include <linux/tty.h>		/* For linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/serialP.h>
 #include <linux/serial_reg.h>
Index: linux-2.6.21-rc7/arch/ppc/syslib/ppc83xx_setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/syslib/ppc83xx_setup.c
+++ linux-2.6.21-rc7/arch/ppc/syslib/ppc83xx_setup.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
 
Index: linux-2.6.21-rc7/arch/ppc/syslib/ppc85xx_setup.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/syslib/ppc85xx_setup.c
+++ linux-2.6.21-rc7/arch/ppc/syslib/ppc85xx_setup.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/serial.h>
-#include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
 
Index: linux-2.6.21-rc7/arch/sh/kernel/early_printk.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/sh/kernel/early_printk.c
+++ linux-2.6.21-rc7/arch/sh/kernel/early_printk.c
@@ -10,7 +10,6 @@
  * for more details.
  */
 #include <linux/console.h>
-#include <linux/tty.h>
 #include <linux/init.h>
 #include <linux/io.h>
 
Index: linux-2.6.21-rc7/drivers/misc/ibmasm/uart.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/misc/ibmasm/uart.c
+++ linux-2.6.21-rc7/drivers/misc/ibmasm/uart.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/termios.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
Index: linux-2.6.21-rc7/drivers/parisc/superio.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/parisc/superio.c
+++ linux-2.6.21-rc7/drivers/parisc/superio.c
@@ -71,7 +71,6 @@
 #include <linux/parport.h>
 #include <linux/parport_pc.h>
 #include <linux/termios.h>
-#include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/delay.h>
 
Index: linux-2.6.21-rc7/arch/powerpc/platforms/celleb/scc_sio.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/powerpc/platforms/celleb/scc_sio.c
+++ linux-2.6.21-rc7/arch/powerpc/platforms/celleb/scc_sio.c
@@ -18,7 +18,6 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/console.h>
Index: linux-2.6.21-rc7/arch/ppc/platforms/4xx/taishan.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ppc/platforms/4xx/taishan.c
+++ linux-2.6.21-rc7/arch/ppc/platforms/4xx/taishan.c
@@ -27,7 +27,6 @@
 #include <linux/initrd.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
