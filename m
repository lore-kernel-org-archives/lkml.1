Return-Path: <linux-kernel-owner+w=401wt.eu-S1764849AbYESWCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764849AbYESWCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYESWBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:01:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40013 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764119AbYESWB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:01:28 -0400
Date: Tue, 20 May 2008 00:59:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/serial/: remove CVS keywords
Message-ID: <20080519215922.GV17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time in 
comments, printk's and MODULE_DESCRIPTION's (no printk's or 
MODULE_DESCRIPTION's are completely removed).

While doing this I also found and fixed a missing \n in a printk
in m32r_sio.c

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/serial/21285.c                  |    6 ++----
 drivers/serial/8250.c                   |    6 ++----
 drivers/serial/8250.h                   |    2 --
 drivers/serial/8250_pci.c               |    2 --
 drivers/serial/8250_pnp.c               |    2 --
 drivers/serial/Kconfig                  |    2 --
 drivers/serial/Makefile                 |    2 --
 drivers/serial/amba-pl010.c             |    6 ++----
 drivers/serial/amba-pl011.c             |    2 --
 drivers/serial/clps711x.c               |    7 ++-----
 drivers/serial/cpm_uart/cpm_uart_core.c |    4 ++--
 drivers/serial/m32r_sio.c               |    4 ++--
 drivers/serial/mpsc.c                   |    4 ++--
 drivers/serial/pnx8xxx_uart.c           |    2 +-
 drivers/serial/sa1100.c                 |    7 ++-----
 drivers/serial/sunsu.c                  |    2 +-
 16 files changed, 18 insertions(+), 42 deletions(-)

8390d3debfb40bd3132f1e687529b6e6a5187112 diff --git a/drivers/serial/21285.c b/drivers/serial/21285.c
index 0276471..1b6b83c 100644
--- a/drivers/serial/21285.c
+++ b/drivers/serial/21285.c
@@ -4,8 +4,6 @@
  * Driver for the serial port on the 21285 StrongArm-110 core logic chip.
  *
  * Based on drivers/char/serial.c
- *
- *  $Id: 21285.c,v 1.37 2002/07/28 10:03:27 rmk Exp $
  */
 #include <linux/module.h>
 #include <linux/tty.h>
@@ -494,7 +492,7 @@ static int __init serial21285_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Serial: 21285 driver $Revision: 1.37 $\n");
+	printk(KERN_INFO "Serial: 21285 driver\n");
 
 	serial21285_setup_ports();
 
@@ -515,5 +513,5 @@ module_init(serial21285_init);
 module_exit(serial21285_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Intel Footbridge (21285) serial driver $Revision: 1.37 $");
+MODULE_DESCRIPTION("Intel Footbridge (21285) serial driver");
 MODULE_ALIAS_CHARDEV(SERIAL_21285_MAJOR, SERIAL_21285_MINOR);
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index a1ca9b7..bb64de3 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -12,8 +12,6 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
- *  $Id: 8250.c,v 1.90 2002/07/28 10:03:27 rmk Exp $
- *
  * A note about mapbase / membase
  *
  *  mapbase is the physical address of the IO port.
@@ -2932,7 +2930,7 @@ static int __init serial8250_init(void)
 	if (nr_uarts > UART_NR)
 		nr_uarts = UART_NR;
 
-	printk(KERN_INFO "Serial: 8250/16550 driver $Revision: 1.90 $ "
+	printk(KERN_INFO "Serial: 8250/16550 driver"
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
@@ -2993,7 +2991,7 @@ EXPORT_SYMBOL(serial8250_suspend_port);
 EXPORT_SYMBOL(serial8250_resume_port);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Generic 8250/16x50 serial driver $Revision: 1.90 $");
+MODULE_DESCRIPTION("Generic 8250/16x50 serial driver");
 
 module_param(share_irqs, uint, 0644);
 MODULE_PARM_DESC(share_irqs, "Share IRQs with other non-8250/16x50 devices"
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 91bd28f..78c0016 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -11,8 +11,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
- *
- *  $Id: 8250.h,v 1.8 2002/07/21 21:32:30 rmk Exp $
  */
 
 #include <linux/serial_8250.h>
diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 53fa19c..3bd9f01 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -10,8 +10,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License.
- *
- *  $Id: 8250_pci.c,v 1.28 2002/11/02 11:14:18 rmk Exp $
  */
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index 97c68d0..ec522b3 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -12,8 +12,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License.
- *
- *  $Id: 8250_pnp.c,v 1.10 2002/07/21 21:32:30 rmk Exp $
  */
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 62e6eb1..92ff806 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1,8 +1,6 @@
 #
 # Serial device configuration
 #
-# $Id: Kconfig,v 1.11 2004/03/11 18:08:04 lethal Exp $
-#
 
 menu "Serial drivers"
 	depends on HAS_IOMEM
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 0d9c09b..34e89a4 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -1,8 +1,6 @@
 #
 # Makefile for the kernel serial device drivers.
 #
-#  $Id: Makefile,v 1.8 2002/07/21 21:32:30 rmk Exp $
-#
 
 obj-$(CONFIG_SERIAL_CORE) += serial_core.o
 obj-$(CONFIG_SERIAL_21285) += 21285.o
diff --git a/drivers/serial/amba-pl010.c b/drivers/serial/amba-pl010.c
index e88da72..0df6e40 100644
--- a/drivers/serial/amba-pl010.c
+++ b/drivers/serial/amba-pl010.c
@@ -22,8 +22,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- *  $Id: amba.c,v 1.41 2002/07/28 10:03:27 rmk Exp $
- *
  * This is a generic driver for ARM AMBA-type serial ports.  They
  * have a lot of 16550-like features, but are not register compatible.
  * Note that although they do have CTS, DCD and DSR inputs, they do
@@ -791,7 +789,7 @@ static int __init pl010_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Serial: AMBA driver $Revision: 1.41 $\n");
+	printk(KERN_INFO "Serial: AMBA driver\n");
 
 	ret = uart_register_driver(&amba_reg);
 	if (ret == 0) {
@@ -812,5 +810,5 @@ module_init(pl010_init);
 module_exit(pl010_exit);
 
 MODULE_AUTHOR("ARM Ltd/Deep Blue Solutions Ltd");
-MODULE_DESCRIPTION("ARM AMBA serial port driver $Revision: 1.41 $");
+MODULE_DESCRIPTION("ARM AMBA serial port driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 08adc1d..8b5aa0b 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -22,8 +22,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- *  $Id: amba.c,v 1.41 2002/07/28 10:03:27 rmk Exp $
- *
  * This is a generic driver for ARM AMBA-type serial ports.  They
  * have a lot of 16550-like features, but are not register compatible.
  * Note that although they do have CTS, DCD and DSR inputs, they do
diff --git a/drivers/serial/clps711x.c b/drivers/serial/clps711x.c
index 2382718..c6495f7 100644
--- a/drivers/serial/clps711x.c
+++ b/drivers/serial/clps711x.c
@@ -21,9 +21,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- *  $Id: clps711x.c,v 1.42 2002/07/28 10:03:28 rmk Exp $
- *
  */
 
 #if defined(CONFIG_SERIAL_CLPS711X_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -551,7 +548,7 @@ static int __init clps711xuart_init(void)
 {
 	int ret, i;
 
-	printk(KERN_INFO "Serial: CLPS711x driver $Revision: 1.42 $\n");
+	printk(KERN_INFO "Serial: CLPS711x driver\n");
 
 	ret = uart_register_driver(&clps711x_reg);
 	if (ret)
@@ -577,6 +574,6 @@ module_init(clps711xuart_init);
 module_exit(clps711xuart_exit);
 
 MODULE_AUTHOR("Deep Blue Solutions Ltd");
-MODULE_DESCRIPTION("CLPS-711x generic serial driver $Revision: 1.42 $");
+MODULE_DESCRIPTION("CLPS-711x generic serial driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV(SERIAL_CLPS711X_MAJOR, SERIAL_CLPS711X_MINOR);
diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index a19dc7e..74935a5 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -1530,7 +1530,7 @@ static int cpm_uart_init(void) {
 	int ret;
 	int i;
 	struct device *dev;
-	printk(KERN_INFO "Serial: CPM driver $Revision: 0.02 $\n");
+	printk(KERN_INFO "Serial: CPM driver\n");
 
 	/* lookup the bus for uart devices */
 	dev = bus_find_device(&platform_bus_type, NULL, 0, match_is_uart);
@@ -1591,6 +1591,6 @@ module_init(cpm_uart_init);
 module_exit(cpm_uart_exit);
 
 MODULE_AUTHOR("Kumar Gala/Antoniou Pantelis");
-MODULE_DESCRIPTION("CPM SCC/SMC port driver $Revision: 0.01 $");
+MODULE_DESCRIPTION("CPM SCC/SMC port driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV(SERIAL_CPM_MAJOR, SERIAL_CPM_MINOR);
diff --git a/drivers/serial/m32r_sio.c b/drivers/serial/m32r_sio.c
index c2bb11c..60a95bb 100644
--- a/drivers/serial/m32r_sio.c
+++ b/drivers/serial/m32r_sio.c
@@ -1160,7 +1160,7 @@ static int __init m32r_sio_init(void)
 {
 	int ret, i;
 
-	printk(KERN_INFO "Serial: M32R SIO driver $Revision: 1.11 $ ");
+	printk(KERN_INFO "Serial: M32R SIO driver\n");
 
 	for (i = 0; i < NR_IRQS; i++)
 		spin_lock_init(&irq_lists[i].lock);
@@ -1189,4 +1189,4 @@ EXPORT_SYMBOL(m32r_sio_suspend_port);
 EXPORT_SYMBOL(m32r_sio_resume_port);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Generic M32R SIO serial driver $Revision: 1.11 $");
+MODULE_DESCRIPTION("Generic M32R SIO serial driver");
diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index e8819c4..da596e7 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -1972,7 +1972,7 @@ static int __init mpsc_drv_init(void)
 {
 	int	rc;
 
-	printk(KERN_INFO "Serial: MPSC driver $Revision: 1.00 $\n");
+	printk(KERN_INFO "Serial: MPSC driver\n");
 
 	memset(mpsc_ports, 0, sizeof(mpsc_ports));
 	memset(&mpsc_shared_regs, 0, sizeof(mpsc_shared_regs));
@@ -2004,7 +2004,7 @@ module_init(mpsc_drv_init);
 module_exit(mpsc_drv_exit);
 
 MODULE_AUTHOR("Mark A. Greer <mgreer@mvista.com>");
-MODULE_DESCRIPTION("Generic Marvell MPSC serial/UART driver $Revision: 1.00 $");
+MODULE_DESCRIPTION("Generic Marvell MPSC serial/UART driver");
 MODULE_VERSION(MPSC_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(MPSC_MAJOR);
diff --git a/drivers/serial/pnx8xxx_uart.c b/drivers/serial/pnx8xxx_uart.c
index d0e5a79..1ba5917 100644
--- a/drivers/serial/pnx8xxx_uart.c
+++ b/drivers/serial/pnx8xxx_uart.c
@@ -824,7 +824,7 @@ static int __init pnx8xxx_serial_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Serial: PNX8XXX driver $Revision: 1.2 $\n");
+	printk(KERN_INFO "Serial: PNX8XXX driver\n");
 
 	pnx8xxx_init_ports();
 
diff --git a/drivers/serial/sa1100.c b/drivers/serial/sa1100.c
index 62b3858..f3cf7fe 100644
--- a/drivers/serial/sa1100.c
+++ b/drivers/serial/sa1100.c
@@ -20,9 +20,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- *  $Id: sa1100.c,v 1.50 2002/07/29 14:41:04 rmk Exp $
- *
  */
 
 #if defined(CONFIG_SERIAL_SA1100_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -892,7 +889,7 @@ static int __init sa1100_serial_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Serial: SA11x0 driver $Revision: 1.50 $\n");
+	printk(KERN_INFO "Serial: SA11x0 driver\n");
 
 	sa1100_init_ports();
 
@@ -915,7 +912,7 @@ module_init(sa1100_serial_init);
 module_exit(sa1100_serial_exit);
 
 MODULE_AUTHOR("Deep Blue Solutions Ltd");
-MODULE_DESCRIPTION("SA1100 generic serial port driver $Revision: 1.50 $");
+MODULE_DESCRIPTION("SA1100 generic serial port driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SERIAL_SA1100_MAJOR);
 MODULE_ALIAS("platform:sa11x0-uart");
diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index 03806a9..1074e73 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1,4 +1,4 @@
-/* $Id: su.c,v 1.55 2002/01/08 16:00:16 davem Exp $
+/*
  * su.c: Small serial driver for keyboard/mouse interface on sparc32/PCI
  *
  * Copyright (C) 1997  Eddie C. Dost  (ecd@skynet.be)

