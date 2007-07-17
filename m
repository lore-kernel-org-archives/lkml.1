Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbXGQRgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbXGQRgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbXGQRg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:36:28 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63946 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbXGQRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:36:26 -0400
Date: Tue, 17 Jul 2007 10:39:57 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] serial: add back early_serial_setup back to head file
In-reply-to: <15587.1184685298@redhat.com>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Russell King <rmk@arm.linux.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707171039.58182.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <15587.1184685298@redhat.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] serial: add back early_serial_setup back to head file

early_serial_setup is removed from serial.h, but foget to put in
serial_8250.h

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index c1c32e4..a74c087 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -29,6 +29,7 @@
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
+#include <linux/serial_8250.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/mips/basler/excite/excite_setup.c b/arch/mips/basler/excite/excite_setup.c
index 2f0e4c0..5600318 100644
--- a/arch/mips/basler/excite/excite_setup.c
+++ b/arch/mips/basler/excite/excite_setup.c
@@ -26,6 +26,7 @@
 #include <linux/tty.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
+#include <linux/serial_8250.h>
 #include <linux/ioport.h>
 #include <linux/spinlock.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/gt64120/wrppmc/setup.c b/arch/mips/gt64120/wrppmc/setup.c
index ea96552..ed58c13 100644
--- a/arch/mips/gt64120/wrppmc/setup.c
+++ b/arch/mips/gt64120/wrppmc/setup.c
@@ -14,6 +14,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/pm.h>
 
 #include <asm/io.h>
diff --git a/arch/mips/mips-boards/atlas/atlas_setup.c b/arch/mips/mips-boards/atlas/atlas_setup.c
index 1cc6ebb..c68358a 100644
--- a/arch/mips/mips-boards/atlas/atlas_setup.c
+++ b/arch/mips/mips-boards/atlas/atlas_setup.c
@@ -22,6 +22,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/mips-boards/sead/sead_setup.c b/arch/mips/mips-boards/sead/sead_setup.c
index bb80140..5f70eaf 100644
--- a/arch/mips/mips-boards/sead/sead_setup.c
+++ b/arch/mips/mips-boards/sead/sead_setup.c
@@ -23,6 +23,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/mipssim/sim_setup.c b/arch/mips/mipssim/sim_setup.c
index 60e6690..17819b5 100644
--- a/arch/mips/mipssim/sim_setup.c
+++ b/arch/mips/mipssim/sim_setup.c
@@ -26,6 +26,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_serial.c b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
index c41b53f..e25bac5 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_serial.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
@@ -32,6 +32,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/serial.h>
+#include <linux/serial_8250.h>
 
 #include <msp_prom.h>
 #include <msp_int.h>
diff --git a/arch/mips/pmc-sierra/yosemite/setup.c b/arch/mips/pmc-sierra/yosemite/setup.c
index 6a6e15e..f7f93ae 100644
--- a/arch/mips/pmc-sierra/yosemite/setup.c
+++ b/arch/mips/pmc-sierra/yosemite/setup.c
@@ -39,6 +39,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/time.h>
 #include <asm/bootinfo.h>
diff --git a/arch/ppc/platforms/4xx/bamboo.c b/arch/ppc/platforms/4xx/bamboo.c
index 349660b..017623c 100644
--- a/arch/ppc/platforms/4xx/bamboo.c
+++ b/arch/ppc/platforms/4xx/bamboo.c
@@ -29,6 +29,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/ethtool.h>
 
 #include <asm/system.h>
diff --git a/arch/ppc/platforms/4xx/bubinga.c b/arch/ppc/platforms/4xx/bubinga.c
index 1a7f075..cd696be 100644
--- a/arch/ppc/platforms/4xx/bubinga.c
+++ b/arch/ppc/platforms/4xx/bubinga.c
@@ -21,6 +21,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/ppc/platforms/4xx/cpci405.c b/arch/ppc/platforms/4xx/cpci405.c
index 8474b05..2e7e25d 100644
--- a/arch/ppc/platforms/4xx/cpci405.c
+++ b/arch/ppc/platforms/4xx/cpci405.c
@@ -23,6 +23,7 @@
 #include <asm/todc.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <asm/ocp.h>
 #include <asm/ibm_ocp_pci.h>
 #include <platforms/4xx/ibm405gp.h>
diff --git a/arch/ppc/platforms/4xx/ebony.c b/arch/ppc/platforms/4xx/ebony.c
index f0f9cc8..05d7184 100644
--- a/arch/ppc/platforms/4xx/ebony.c
+++ b/arch/ppc/platforms/4xx/ebony.c
@@ -32,6 +32,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/ppc/platforms/4xx/luan.c b/arch/ppc/platforms/4xx/luan.c
index 61706ef..4b16961 100644
--- a/arch/ppc/platforms/4xx/luan.c
+++ b/arch/ppc/platforms/4xx/luan.c
@@ -30,6 +30,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/ppc/platforms/4xx/ocotea.c b/arch/ppc/platforms/4xx/ocotea.c
index 5e994e1..fd0f971 100644
--- a/arch/ppc/platforms/4xx/ocotea.c
+++ b/arch/ppc/platforms/4xx/ocotea.c
@@ -30,6 +30,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/ppc/platforms/4xx/taishan.c b/arch/ppc/platforms/4xx/taishan.c
index 5d9af8d..888c492 100644
--- a/arch/ppc/platforms/4xx/taishan.c
+++ b/arch/ppc/platforms/4xx/taishan.c
@@ -30,6 +30,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
diff --git a/arch/ppc/platforms/4xx/yucca.c b/arch/ppc/platforms/4xx/yucca.c
index 346787d..a83b0ba 100644
--- a/arch/ppc/platforms/4xx/yucca.c
+++ b/arch/ppc/platforms/4xx/yucca.c
@@ -31,6 +31,7 @@
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/ppc/platforms/85xx/sbc8560.c b/arch/ppc/platforms/85xx/sbc8560.c
index 1d10ab9..3d7addb 100644
--- a/arch/ppc/platforms/85xx/sbc8560.c
+++ b/arch/ppc/platforms/85xx/sbc8560.c
@@ -26,6 +26,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>	/* for linux/serial_core.h */
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
 #include <linux/fsl_devices.h>
diff --git a/arch/ppc/platforms/chestnut.c b/arch/ppc/platforms/chestnut.c
index a764ae7..248684f 100644
--- a/arch/ppc/platforms/chestnut.c
+++ b/arch/ppc/platforms/chestnut.c
@@ -25,6 +25,7 @@
 #include <linux/ide.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/mtd/physmap.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/ppc/platforms/ev64260.c b/arch/ppc/platforms/ev64260.c
index 4957a7b..976270d 100644
--- a/arch/ppc/platforms/ev64260.c
+++ b/arch/ppc/platforms/ev64260.c
@@ -35,6 +35,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #else
 #include <linux/mv643xx.h>
 #endif
diff --git a/arch/ppc/platforms/radstone_ppc7d.c b/arch/ppc/platforms/radstone_ppc7d.c
index b558607..44d4398 100644
--- a/arch/ppc/platforms/radstone_ppc7d.c
+++ b/arch/ppc/platforms/radstone_ppc7d.c
@@ -35,6 +35,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>		/* for linux/serial_core.h */
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/mv643xx.h>
 #include <linux/netdevice.h>
 #include <linux/platform_device.h>
diff --git a/arch/ppc/platforms/spruce.c b/arch/ppc/platforms/spruce.c
index 3c78427..f4de50b 100644
--- a/arch/ppc/platforms/spruce.c
+++ b/arch/ppc/platforms/spruce.c
@@ -27,6 +27,7 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index a708c32..38cdf9f 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -73,6 +73,7 @@
 #include <linux/termios.h>
 #include <linux/tty.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/delay.h>
 
 #include <asm/io.h>
diff --git a/drivers/serial/8250_hp300.c b/drivers/serial/8250_hp300.c
index 53e81a4..2cf0953 100644
--- a/drivers/serial/8250_hp300.c
+++ b/drivers/serial/8250_hp300.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
+#include <linux/serial_8250.h>
 #include <linux/delay.h>
 #include <linux/dio.h>
 #include <linux/console.h>
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 706ee9a..8518fa2 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -60,6 +60,8 @@ void serial8250_unregister_port(int line);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
 
+extern int early_serial_setup(struct uart_port *port);
+
 extern int serial8250_find_port(struct uart_port *p);
 extern int serial8250_find_port_for_earlycon(void);
 extern int setup_early_serial8250_console(char *cmdline);
