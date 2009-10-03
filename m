Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbZJCIey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbZJCIey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 04:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZJCIey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 04:34:54 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:60178 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZJCIet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 04:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=pw+rqf2T0QO10nsaXtlRyuM+HmuY4AM/EScUxolk0JxQjGb8+qSIl1SOupk06AshR6
         AXuI6QfrfrC/o4mS4zKFQfD2Kd57lvRJIk6TtBteqXZqjJa2nPejH+nMnTtC0inhmA/4
         rGsDW7aMBDNkvyPdV/UTZxwU/mLuTlzBYkGWc=
Message-ID: <4AC70CA3.30204@gmail.com>
Date: Sat, 03 Oct 2009 16:34:43 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NUC900: Add support for nuc932 SoC
Content-Type: multipart/mixed;
 boundary="------------070107090203000901060708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070107090203000901060708
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit

Add "CC" to LKML

--------------070107090203000901060708
Content-Type: message/rfc822;
 name="[PATCH] NUC900: Add support for nuc932 SoC.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[PATCH] NUC900: Add support for nuc932 SoC.eml"

X-Mozilla-Keys: 
Message-ID: <4AC70975.1030702@gmail.com>
Date: Sat, 03 Oct 2009 16:21:09 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
 Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] NUC900: Add support for nuc932 SoC
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit

Dear Russell,

The NUC932 is not same to NUC900 series SoCs, which contains sensor interface supports, H/W JPEG image codec,TV-Out and there are not different register addressing between them,but there are the same IPs in VIC, uart, timer.so I add the nuc932 platform to my nuc900 and modify some interfaces of nuc900 to apply to nuc932, for avoiding wasteful duplication of codes.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>


---
 arch/arm/mach-w90x900/Kconfig                |   15 +++
 arch/arm/mach-w90x900/Makefile               |   12 ++-
 arch/arm/mach-w90x900/clock.c                |    2 +-
 arch/arm/mach-w90x900/clock.h                |    6 +
 arch/arm/mach-w90x900/cpu.c                  |   18 +++-
 arch/arm/mach-w90x900/cpu.h                  |    5 +-
 arch/arm/mach-w90x900/dev_932.c              |   44 ++++++++
 arch/arm/mach-w90x900/groupirq.c             |  140 ++++++++++++++++++++++++++
 arch/arm/mach-w90x900/groupirq.h             |   16 +++
 arch/arm/mach-w90x900/include/mach/irqs.h    |   44 ++++++++
 arch/arm/mach-w90x900/include/mach/map.h     |  105 ++++----------------
 arch/arm/mach-w90x900/include/mach/reg_900.h |   93 +++++++++++++++++
 arch/arm/mach-w90x900/include/mach/reg_932.h |   57 +++++++++++
 arch/arm/mach-w90x900/irq.c                  |  139 +-------------------------
 arch/arm/mach-w90x900/mach-nuc932evb.c       |   42 ++++++++
 arch/arm/mach-w90x900/nuc910.c               |    3 +-
 arch/arm/mach-w90x900/nuc932.c               |   54 ++++++++++
 arch/arm/mach-w90x900/nuc932.h               |   28 +++++
 arch/arm/mach-w90x900/nuc950.c               |    2 +-
 arch/arm/mach-w90x900/nuc960.c               |    2 +-
 arch/arm/mach-w90x900/time.c                 |   69 +------------
 arch/arm/mach-w90x900/time.h                 |   33 ++++++
 arch/arm/mach-w90x900/time_900.c             |   90 +++++++++++++++++
 arch/arm/mach-w90x900/time_932.c             |   59 +++++++++++
 24 files changed, 780 insertions(+), 298 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/dev_932.c
 create mode 100644 arch/arm/mach-w90x900/groupirq.c
 create mode 100644 arch/arm/mach-w90x900/groupirq.h
 create mode 100644 arch/arm/mach-w90x900/include/mach/reg_900.h
 create mode 100644 arch/arm/mach-w90x900/include/mach/reg_932.h
 create mode 100644 arch/arm/mach-w90x900/mach-nuc932evb.c
 create mode 100644 arch/arm/mach-w90x900/nuc932.c
 create mode 100644 arch/arm/mach-w90x900/nuc932.h
 create mode 100644 arch/arm/mach-w90x900/time.h
 create mode 100644 arch/arm/mach-w90x900/time_900.c
 create mode 100644 arch/arm/mach-w90x900/time_932.c

diff --git a/arch/arm/mach-w90x900/Kconfig b/arch/arm/mach-w90x900/Kconfig
index 69bab32..f4b96fe 100644
--- a/arch/arm/mach-w90x900/Kconfig
+++ b/arch/arm/mach-w90x900/Kconfig
@@ -15,6 +15,11 @@ config CPU_NUC960
 	help
 	  Support for NUCP960 of Nuvoton NUC900 CPUs.
 
+config CPU_NUC932
+	bool
+	help
+	  Support for NUCP932 of Nuvoton NUC900 CPUs.
+
 menu "W90P910 Machines"
 
 config MACH_W90P910EVB
@@ -46,4 +51,14 @@ config MACH_W90N960EVB
 
 endmenu
 
+menu "NUC932 Machines"
+
+config MACH_NUC932EVB
+	bool "Nuvoton NUC932 Evaluation Board"
+	select CPU_NUC932
+	help
+	   Say Y here if you are using the Nuvoton NUC932EVB
+
+endmenu
+
 endif
diff --git a/arch/arm/mach-w90x900/Makefile b/arch/arm/mach-w90x900/Makefile
index 828c032..69631f6 100644
--- a/arch/arm/mach-w90x900/Makefile
+++ b/arch/arm/mach-w90x900/Makefile
@@ -4,16 +4,24 @@
 
 # Object file lists.
 
-obj-y				:= irq.o time.o mfp.o gpio.o clock.o
-obj-y				+= clksel.o dev.o cpu.o
+obj-y				:= irq.o time.o cpu.o clock.o clksel.o mfp.o
+
+ifndef CONFIG_CPU_NUC932
+obj-y				+= dev.o groupirq.o time_900.o
+else
+obj-y				+= dev_932.o time_932.o
+endif
+
 # W90X900 CPU support files
 
 obj-$(CONFIG_CPU_W90P910)	+= nuc910.o
 obj-$(CONFIG_CPU_NUC950)	+= nuc950.o
 obj-$(CONFIG_CPU_NUC960)	+= nuc960.o
+obj-$(CONFIG_CPU_NUC932)	+= nuc932.o
 
 # machine support
 
 obj-$(CONFIG_MACH_W90P910EVB)	+= mach-nuc910evb.o
 obj-$(CONFIG_MACH_W90P950EVB)	+= mach-nuc950evb.o
 obj-$(CONFIG_MACH_W90N960EVB)	+= mach-nuc960evb.o
+obj-$(CONFIG_MACH_NUC932EVB)	+= mach-nuc932evb.o
diff --git a/arch/arm/mach-w90x900/clock.c b/arch/arm/mach-w90x900/clock.c
index b785994..df6e63b 100644
--- a/arch/arm/mach-w90x900/clock.c
+++ b/arch/arm/mach-w90x900/clock.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL(clk_disable);
 
 unsigned long clk_get_rate(struct clk *clk)
 {
-	return 15000000;
+	return EXTCLK;
 }
 EXPORT_SYMBOL(clk_get_rate);
 
diff --git a/arch/arm/mach-w90x900/clock.h b/arch/arm/mach-w90x900/clock.h
index f5816a0..b9ea2e6 100644
--- a/arch/arm/mach-w90x900/clock.h
+++ b/arch/arm/mach-w90x900/clock.h
@@ -12,6 +12,12 @@
 
 #include <asm/clkdev.h>
 
+#ifndef CONFIG_CPU_NUC932
+#define EXTCLK	15000000
+#else
+#define EXTCLK	27000000
+#endif
+
 void nuc900_clk_enable(struct clk *clk, int enable);
 void nuc900_subclk_enable(struct clk *clk, int enable);
 void clks_register(struct clk_lookup *clks, size_t num);
diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 921cef9..401b1c8 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -35,7 +35,7 @@
 #include <mach/regs-ebi.h>
 
 #include "cpu.h"
-#include "clock.h"
+
 
 /* Initial IO mappings */
 
@@ -201,12 +201,24 @@ void __init nuc900_map_io(struct map_desc *mach_desc, int mach_size)
 		printk(KERN_INFO "CPU type 0x%08lx is NUC950\n", idcode);
 	else if (idcode == NUC960_CPUID)
 		printk(KERN_INFO "CPU type 0x%08lx is NUC960\n", idcode);
+	else if (idcode == NUC932_CPUID)
+		printk(KERN_INFO "CPU type 0x%08lx is NUC932\n", idcode);
 }
 
 /*Init NUC900 clock*/
 
-void __init nuc900_init_clocks(void)
+void __init nuc900_init_clocks(struct clk_lookup *clks, size_t num)
 {
-	clks_register(nuc900_clkregs, ARRAY_SIZE(nuc900_clkregs));
+	struct clk_lookup *pclks;
+	size_t pnum;
+
+	if (clks == NULL) {
+		pclks = nuc900_clkregs;
+		pnum = ARRAY_SIZE(nuc900_clkregs);
+	} else {
+		pclks = clks;
+		pnum = num;
+	}
+	clks_register(pclks, pnum);
 }
 
diff --git a/arch/arm/mach-w90x900/cpu.h b/arch/arm/mach-w90x900/cpu.h
index 4d58ba1..4493d4d 100644
--- a/arch/arm/mach-w90x900/cpu.h
+++ b/arch/arm/mach-w90x900/cpu.h
@@ -15,6 +15,7 @@
  * published by the Free Software Foundation.
  *
  */
+#include "clock.h"
 
 #define IODESC_ENT(y)                                  \
 {                                                      \
@@ -42,13 +43,15 @@
 #define NUC920_CPUID	0x02900920
 #define NUC950_CPUID	0x02900950
 #define NUC960_CPUID	0x02900960
+#define NUC932_CPUID	0x29550091
 
 /* extern file from cpu.c */
 
 extern void nuc900_clock_source(struct device *dev, unsigned char *src);
-extern void nuc900_init_clocks(void);
+extern void nuc900_init_clocks(struct clk_lookup *clks, size_t num);
 extern void nuc900_map_io(struct map_desc *mach_desc, int mach_size);
 extern void nuc900_board_init(struct platform_device **device, int size);
+extern void nuc932_dev_board_init(void);
 
 /* for either public between 910 and 920, or between 920 and 950 */
 
diff --git a/arch/arm/mach-w90x900/dev_932.c b/arch/arm/mach-w90x900/dev_932.c
new file mode 100644
index 0000000..c2d2cef
--- /dev/null
+++ b/arch/arm/mach-w90x900/dev_932.c
@@ -0,0 +1,44 @@
+/*
+ * linux/arch/arm/mach-w90x900/dev_932.c
+ *
+ * Copyright (C) 2009 Nuvoton corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach-types.h>
+
+#include <mach/regs-serial.h>
+#include <mach/map.h>
+
+#include "cpu.h"
+
+/*Here should be your evb resourse,such as LCD*/
+
+static struct platform_device *nuc932_dev[] __initdata = {
+	&nuc900_serial_device,
+};
+
+/* Provide adding specific CPU platform devices API */
+
+void __init nuc932_dev_board_init(void)
+{
+	platform_add_devices(nuc932_dev, ARRAY_SIZE(nuc932_dev));
+}
+
diff --git a/arch/arm/mach-w90x900/groupirq.c b/arch/arm/mach-w90x900/groupirq.c
new file mode 100644
index 0000000..b3a74db
--- /dev/null
+++ b/arch/arm/mach-w90x900/groupirq.c
@@ -0,0 +1,140 @@
+/*
+ * linux/arch/arm/mach-w90x900/groupirq.c
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/ptrace.h>
+#include <linux/sysdev.h>
+#include <linux/io.h>
+
+#include <asm/irq.h>
+#include <asm/mach/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/regs-irq.h>
+
+struct group_irq {
+	unsigned long		gpen;
+	unsigned int		enabled;
+	void			(*enable)(struct group_irq *, int enable);
+};
+
+static DEFINE_SPINLOCK(groupirq_lock);
+
+#define DEFINE_GROUP(_name, _ctrlbit, _num)				\
+struct group_irq group_##_name = {					\
+		.enable		= nuc900_group_enable,			\
+		.gpen		= ((1 << _num) - 1) << _ctrlbit,	\
+	}
+
+static void nuc900_group_enable(struct group_irq *gpirq, int enable);
+
+static DEFINE_GROUP(nirq0, 0, 4);
+static DEFINE_GROUP(nirq1, 4, 4);
+static DEFINE_GROUP(usbh, 8, 2);
+static DEFINE_GROUP(ottimer, 16, 3);
+static DEFINE_GROUP(gdma, 20, 2);
+static DEFINE_GROUP(sc, 24, 2);
+static DEFINE_GROUP(i2c, 26, 2);
+static DEFINE_GROUP(ps2, 28, 2);
+
+static int group_irq_enable(struct group_irq *group_irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&groupirq_lock, flags);
+	if (group_irq->enabled++ == 0)
+		(group_irq->enable)(group_irq, 1);
+	spin_unlock_irqrestore(&groupirq_lock, flags);
+
+	return 0;
+}
+
+static void group_irq_disable(struct group_irq *group_irq)
+{
+	unsigned long flags;
+
+	WARN_ON(group_irq->enabled == 0);
+
+	spin_lock_irqsave(&groupirq_lock, flags);
+	if (--group_irq->enabled == 0)
+		(group_irq->enable)(group_irq, 0);
+	spin_unlock_irqrestore(&groupirq_lock, flags);
+}
+
+static void nuc900_group_enable(struct group_irq *gpirq, int enable)
+{
+	unsigned int groupen = gpirq->gpen;
+	unsigned long regval;
+
+	regval = __raw_readl(REG_AIC_GEN);
+
+	if (enable)
+		regval |= groupen;
+	else
+		regval &= ~groupen;
+
+	__raw_writel(regval, REG_AIC_GEN);
+}
+
+void nuc900_groupirq_mask(unsigned int irq, unsigned int mask)
+{
+	struct group_irq *group_irq;
+
+	group_irq = NULL;
+
+	switch (irq) {
+	case IRQ_GROUP0:
+		group_irq = &group_nirq0;
+		break;
+
+	case IRQ_GROUP1:
+		group_irq = &group_nirq1;
+		break;
+
+	case IRQ_USBH:
+		group_irq = &group_usbh;
+		break;
+
+	case IRQ_T_INT_GROUP:
+		group_irq = &group_ottimer;
+		break;
+
+	case IRQ_GDMAGROUP:
+		group_irq = &group_gdma;
+		break;
+
+	case IRQ_SCGROUP:
+		group_irq = &group_sc;
+		break;
+
+	case IRQ_I2CGROUP:
+		group_irq = &group_i2c;
+		break;
+
+	case IRQ_P2SGROUP:
+		group_irq = &group_ps2;
+		break;
+	}
+
+	if (group_irq) {
+		if (mask)
+			group_irq_disable(group_irq);
+		else
+			group_irq_enable(group_irq);
+	}
+}
+
diff --git a/arch/arm/mach-w90x900/groupirq.h b/arch/arm/mach-w90x900/groupirq.h
new file mode 100644
index 0000000..65fbd8c
--- /dev/null
+++ b/arch/arm/mach-w90x900/groupirq.h
@@ -0,0 +1,16 @@
+/*
+ * arch/arm/mach-w90x900/groupirq.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+extern void nuc900_groupirq_mask(unsigned int irq, unsigned int mask);
diff --git a/arch/arm/mach-w90x900/include/mach/irqs.h b/arch/arm/mach-w90x900/include/mach/irqs.h
index 9d5cba3..1cb105f 100644
--- a/arch/arm/mach-w90x900/include/mach/irqs.h
+++ b/arch/arm/mach-w90x900/include/mach/irqs.h
@@ -28,6 +28,8 @@
 
 /* Main cpu interrupts */
 
+#ifndef CONFIG_CPU_NUC932
+
 #define IRQ_WDT		W90X900_IRQ(1)
 #define IRQ_GROUP0	W90X900_IRQ(2)
 #define IRQ_GROUP1	W90X900_IRQ(3)
@@ -83,4 +85,46 @@
 #define	IRQ_GROUP1_IRQ6	0x00000040
 #define	IRQ_GROUP1_IRQ7	0x00000080
 
+#else
+
+#define IRQ_WDT		W90X900_IRQ(1)
+#define IRQ_IRQ0	W90X900_IRQ(2)
+#define IRQ_IRQ1	W90X900_IRQ(3)
+#define IRQ_IRQ2	W90X900_IRQ(4)
+#define IRQ_IRQ3	W90X900_IRQ(5)
+#define IRQ_USBH	W90X900_IRQ(6)
+#define IRQ_APU		W90X900_IRQ(7)
+#define IRQ_VPOST	W90X900_IRQ(8)
+#define IRQ_ADC		W90X900_IRQ(9)
+#define IRQ_UART0	W90X900_IRQ(10)
+#define IRQ_TIMER0	W90X900_IRQ(11)
+#define IRQ_GPU0	W90X900_IRQ(12)
+#define IRQ_GPU1	W90X900_IRQ(13)
+#define IRQ_GPU2	W90X900_IRQ(14)
+#define IRQ_GPU3	W90X900_IRQ(15)
+#define IRQ_GPU4	W90X900_IRQ(16)
+#define IRQ_VIN		W90X900_IRQ(17)
+#define IRQ_USBD	W90X900_IRQ(18)
+#define IRQ_VRAMLD	W90X900_IRQ(19)
+#define IRQ_GDMA0	W90X900_IRQ(20)
+#define IRQ_GDMA1	W90X900_IRQ(21)
+#define IRQ_SDIO	W90X900_IRQ(22)
+#define IRQ_FMI		W90X900_IRQ(22)
+#define IRQ_JPEG	W90X900_IRQ(23)
+#define IRQ_SPI0	W90X900_IRQ(24)
+#define IRQ_SPI1	W90X900_IRQ(25)
+#define IRQ_RTC		W90X900_IRQ(26)
+#define IRQ_PWM0	W90X900_IRQ(27)
+#define IRQ_PWM1	W90X900_IRQ(28)
+#define IRQ_PWM2	W90X900_IRQ(29)
+#define IRQ_PWM3	W90X900_IRQ(30)
+#define IRQ_I2SAC97	W90X900_IRQ(31)
+#define IRQ_CAP0	IRQ_PWM0
+#define IRQ_CAP1	IRQ_PWM1
+#define IRQ_CAP2	IRQ_PWM2
+#define IRQ_CAP3	IRQ_PWM3
+#define NR_IRQS		(IRQ_I2SAC97 + 1)
+
+#endif
+
 #endif /* __ASM_ARCH_IRQ_H */
diff --git a/arch/arm/mach-w90x900/include/mach/map.h b/arch/arm/mach-w90x900/include/mach/map.h
index 1a20953..33c548f 100644
--- a/arch/arm/mach-w90x900/include/mach/map.h
+++ b/arch/arm/mach-w90x900/include/mach/map.h
@@ -16,142 +16,73 @@
 #ifndef __ASM_ARCH_MAP_H
 #define __ASM_ARCH_MAP_H
 
-#ifndef __ASSEMBLY__
-#define W90X900_ADDR(x)		((void __iomem *)(0xF0000000 + (x)))
+#ifdef CONFIG_CPU_NUC932
+#include "reg_932.h"
 #else
-#define W90X900_ADDR(x)		(0xF0000000 + (x))
+#include "reg_900.h"
 #endif
 
-#define AHB_IO_BASE		0xB0000000
-#define APB_IO_BASE		0xB8000000
-#define CLOCKPW_BASE		(APB_IO_BASE+0x200)
-#define AIC_IO_BASE		(APB_IO_BASE+0x2000)
-#define TIMER_IO_BASE		(APB_IO_BASE+0x1000)
-
 /*
  * interrupt controller is the first thing we put in, to make
  * the assembly code for the irq detection easier
  */
 #define W90X900_VA_IRQ		W90X900_ADDR(0x00000000)
-#define W90X900_PA_IRQ		(0xB8002000)
 #define W90X900_SZ_IRQ		SZ_4K
 
-#define W90X900_VA_GCR		W90X900_ADDR(0x08002000)
-#define W90X900_PA_GCR		(0xB0000000)
+#define W90X900_VA_GCR		W90X900_ADDR(W90X900_PA_IRQ)
+#define W90X900_VA_CLKPWR	(W90X900_VA_GCR+CLK_OFFSET)
 #define W90X900_SZ_GCR		SZ_4K
 
-/* Clock and Power management */
-#define W90X900_VA_CLKPWR	(W90X900_VA_GCR+0x200)
-#define W90X900_PA_CLKPWR	(0xB0000200)
-#define W90X900_SZ_CLKPWR	SZ_4K
-
 /* EBI management */
-#define W90X900_VA_EBI		W90X900_ADDR(0x00001000)
-#define W90X900_PA_EBI		(0xB0001000)
+#define W90X900_VA_EBI		W90X900_ADDR(W90X900_PA_EBI)
 #define W90X900_SZ_EBI		SZ_4K
 
 /* UARTs */
-#define W90X900_VA_UART		W90X900_ADDR(0x08000000)
-#define W90X900_PA_UART		(0xB8000000)
+#define W90X900_VA_UART		W90X900_ADDR(W90X900_PA_UART)
 #define W90X900_SZ_UART		SZ_4K
 
 /* Timers */
-#define W90X900_VA_TIMER	W90X900_ADDR(0x08001000)
-#define W90X900_PA_TIMER	(0xB8001000)
+#define W90X900_VA_TIMER	W90X900_ADDR(W90X900_PA_TIMER)
 #define W90X900_SZ_TIMER	SZ_4K
 
 /* GPIO ports */
-#define W90X900_VA_GPIO		W90X900_ADDR(0x08003000)
-#define W90X900_PA_GPIO		(0xB8003000)
+#define W90X900_VA_GPIO		W90X900_ADDR(W90X900_PA_GPIO)
 #define W90X900_SZ_GPIO		SZ_4K
 
 /* GDMA control */
-#define W90X900_VA_GDMA		W90X900_ADDR(0x00004000)
-#define W90X900_PA_GDMA		(0xB0004000)
+#define W90X900_VA_GDMA		W90X900_ADDR(W90X900_PA_GDMA)
 #define W90X900_SZ_GDMA		SZ_4K
 
-/* USB host controller*/
-#define W90X900_VA_USBEHCIHOST	W90X900_ADDR(0x00005000)
-#define W90X900_PA_USBEHCIHOST	(0xB0005000)
-#define W90X900_SZ_USBEHCIHOST	SZ_4K
-
-#define W90X900_VA_USBOHCIHOST	W90X900_ADDR(0x00007000)
-#define W90X900_PA_USBOHCIHOST	(0xB0007000)
-#define W90X900_SZ_USBOHCIHOST	SZ_4K
-
 /* I2C hardware controller */
-#define W90X900_VA_I2C		W90X900_ADDR(0x08006000)
-#define W90X900_PA_I2C		(0xB8006000)
+#define W90X900_VA_I2C		W90X900_ADDR(W90X900_PA_I2C)
 #define W90X900_SZ_I2C		SZ_4K
 
-/* Keypad Interface*/
-#define W90X900_VA_KPI		W90X900_ADDR(0x08008000)
-#define W90X900_PA_KPI		(0xB8008000)
-#define W90X900_SZ_KPI		SZ_4K
-
-/* Smart card host*/
-#define W90X900_VA_SC		W90X900_ADDR(0x08005000)
-#define W90X900_PA_SC		(0xB8005000)
-#define W90X900_SZ_SC		SZ_4K
-
 /* LCD controller*/
-#define W90X900_VA_LCD		W90X900_ADDR(0x00008000)
-#define W90X900_PA_LCD		(0xB0008000)
+#define W90X900_VA_LCD		W90X900_ADDR(W90X900_PA_LCD)
 #define W90X900_SZ_LCD		SZ_4K
 
 /* 2D controller*/
-#define W90X900_VA_GE		W90X900_ADDR(0x0000B000)
-#define W90X900_PA_GE		(0xB000B000)
+#define W90X900_VA_GE		W90X900_ADDR(W90X900_PA_GE)
 #define W90X900_SZ_GE		SZ_4K
 
-/* ATAPI */
-#define W90X900_VA_ATAPI	W90X900_ADDR(0x0000A000)
-#define W90X900_PA_ATAPI	(0xB000A000)
-#define W90X900_SZ_ATAPI	SZ_4K
-
 /* ADC */
-#define W90X900_VA_ADC		W90X900_ADDR(0x0800A000)
-#define W90X900_PA_ADC		(0xB800A000)
+#define W90X900_VA_ADC		W90X900_ADDR(W90X900_PA_ADC)
 #define W90X900_SZ_ADC		SZ_4K
 
-/* PS2 Interface*/
-#define W90X900_VA_PS2		W90X900_ADDR(0x08009000)
-#define W90X900_PA_PS2		(0xB8009000)
-#define W90X900_SZ_PS2		SZ_4K
-
 /* RTC */
-#define W90X900_VA_RTC		W90X900_ADDR(0x08004000)
-#define W90X900_PA_RTC		(0xB8004000)
+#define W90X900_VA_RTC		W90X900_ADDR(W90X900_PA_RTC)
 #define W90X900_SZ_RTC		SZ_4K
 
 /* Pulse Width Modulation(PWM) Registers */
-#define W90X900_VA_PWM		W90X900_ADDR(0x08007000)
-#define W90X900_PA_PWM		(0xB8007000)
+#define W90X900_VA_PWM		W90X900_ADDR(W90X900_PA_PWM)
 #define W90X900_SZ_PWM		SZ_4K
 
 /* Audio Controller controller */
-#define W90X900_VA_ACTL		W90X900_ADDR(0x00009000)
-#define W90X900_PA_ACTL		(0xB0009000)
+#define W90X900_VA_ACTL		W90X900_ADDR(W90X900_PA_ACTL)
 #define W90X900_SZ_ACTL		SZ_4K
 
-/* DMA controller */
-#define W90X900_VA_DMA		W90X900_ADDR(0x0000c000)
-#define W90X900_PA_DMA		(0xB000c000)
-#define W90X900_SZ_DMA		SZ_4K
-
-/* FMI controller */
-#define W90X900_VA_FMI		W90X900_ADDR(0x0000d000)
-#define W90X900_PA_FMI		(0xB000d000)
-#define W90X900_SZ_FMI		SZ_4K
-
 /* USB Device port */
-#define W90X900_VA_USBDEV	W90X900_ADDR(0x00006000)
-#define W90X900_PA_USBDEV	(0xB0006000)
+#define W90X900_VA_USBDEV	W90X900_ADDR(W90X900_PA_USBDEV)
 #define W90X900_SZ_USBDEV	SZ_4K
 
-/* External MAC control*/
-#define W90X900_VA_EMC		W90X900_ADDR(0x00003000)
-#define W90X900_PA_EMC		(0xB0003000)
-#define W90X900_SZ_EMC		SZ_4K
-
 #endif /* __ASM_ARCH_MAP_H */
diff --git a/arch/arm/mach-w90x900/include/mach/reg_900.h b/arch/arm/mach-w90x900/include/mach/reg_900.h
new file mode 100644
index 0000000..5a07224
--- /dev/null
+++ b/arch/arm/mach-w90x900/include/mach/reg_900.h
@@ -0,0 +1,93 @@
+/*
+ * arch/arm/mach-w90x900/include/mach/reg_900.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#ifndef __ASM_ARCH_REG_H
+#define __ASM_ARCH_REG_H
+
+/*
+ * interrupt controller is the first thing we put in, to make
+ * the assembly code for the irq detection easier
+ */
+
+#define MAP_OFFSET	(0xB0000000)
+#define CLK_OFFSET	(0x200)
+
+#ifndef __ASSEMBLY__
+#define W90X900_ADDR(x)	((void __iomem *)(0xF0000000 + ((x)&(~MAP_OFFSET))))
+#else
+#define W90X900_ADDR(x)	(0xF0000000 + ((x)&(~MAP_OFFSET)))
+#endif
+
+#define W90X900_PA_IRQ		(0xB8002000)
+#define W90X900_PA_GCR		(0xB0000000)
+#define W90X900_PA_CLKPWR	(0xB0000200)
+#define W90X900_PA_EBI		(0xB0001000)
+#define W90X900_PA_UART		(0xB8000000)
+#define W90X900_PA_TIMER	(0xB8001000)
+#define W90X900_PA_GPIO		(0xB8003000)
+#define W90X900_PA_GDMA		(0xB0004000)
+#define W90X900_PA_USBEHCIHOST	(0xB0005000)
+#define W90X900_PA_USBOHCIHOST	(0xB0007000)
+#define W90X900_PA_I2C		(0xB8006000)
+#define W90X900_PA_KPI		(0xB8008000)
+#define W90X900_PA_SC		(0xB8005000)
+#define W90X900_PA_LCD		(0xB0008000)
+#define W90X900_PA_GE		(0xB000B000)
+#define W90X900_PA_ATAPI	(0xB000A000)
+#define W90X900_PA_ADC		(0xB800A000)
+#define W90X900_PA_PS2		(0xB8009000)
+#define W90X900_PA_RTC		(0xB8004000)
+#define W90X900_PA_PWM		(0xB8007000)
+#define W90X900_PA_ACTL		(0xB0009000)
+#define W90X900_PA_DMA		(0xB000c000)
+#define W90X900_PA_FMI		(0xB000d000)
+#define W90X900_PA_USBDEV	(0xB0006000)
+#define W90X900_PA_EMC		(0xB0003000)
+
+
+/* USB host controller*/
+#define W90X900_VA_USBEHCIHOST	W90X900_ADDR(W90X900_PA_USBEHCIHOST)
+#define W90X900_SZ_USBEHCIHOST	SZ_4K
+
+#define W90X900_VA_USBOHCIHOST	W90X900_ADDR(W90X900_PA_USBOHCIHOST)
+#define W90X900_SZ_USBOHCIHOST	SZ_4K
+
+/* Keypad Interface*/
+#define W90X900_VA_KPI		W90X900_ADDR(W90X900_PA_KPI)
+#define W90X900_SZ_KPI		SZ_4K
+
+/* Smart card host*/
+#define W90X900_VA_SC		W90X900_ADDR(W90X900_PA_SC)
+#define W90X900_SZ_SC		SZ_4K
+
+/* ATAPI */
+#define W90X900_VA_ATAPI	W90X900_ADDR(W90X900_PA_ATAPI)
+#define W90X900_SZ_ATAPI	SZ_4K
+
+/* PS2 Interface*/
+#define W90X900_VA_PS2		W90X900_ADDR(W90X900_PA_PS2)
+#define W90X900_SZ_PS2		SZ_4K
+
+/* DMA controller */
+#define W90X900_VA_DMA		W90X900_ADDR(W90X900_PA_DMA)
+#define W90X900_SZ_DMA		SZ_4K
+
+/* FMI controller */
+#define W90X900_VA_FMI		W90X900_ADDR(W90X900_PA_FMI)
+#define W90X900_SZ_FMI		SZ_4K
+
+/* External MAC control*/
+#define W90X900_VA_EMC		W90X900_ADDR(W90X900_PA_EMC)
+#define W90X900_SZ_EMC		SZ_4K
+
+#endif /* __ASM_ARCH_REG_H */
diff --git a/arch/arm/mach-w90x900/include/mach/reg_932.h b/arch/arm/mach-w90x900/include/mach/reg_932.h
new file mode 100644
index 0000000..3ac5a0d
--- /dev/null
+++ b/arch/arm/mach-w90x900/include/mach/reg_932.h
@@ -0,0 +1,57 @@
+/*
+ * arch/arm/mach-w90x900/include/mach/reg_932.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#ifndef __ASM_ARCH_REG_H
+#define __ASM_ARCH_REG_H
+
+#define MAP_OFFSET	(0xfff00000)
+#define CLK_OFFSET	(0x10)
+
+#ifndef __ASSEMBLY__
+#define W90X900_ADDR(x)	((void __iomem *)(0xF0000000 + ((x)&(~MAP_OFFSET))))
+#else
+#define W90X900_ADDR(x)	(0xF0000000 + ((x)&(~MAP_OFFSET)))
+#endif
+
+#define W90X900_PA_IRQ		(0xFFF83000)
+#define W90X900_PA_GCR		(0xFFF00000)
+#define W90X900_PA_EBI		(0xFFF01000)
+#define W90X900_PA_UART		(0xFFF80000)
+#define W90X900_PA_TIMER	(0xFFF81000)
+#define W90X900_PA_GPIO		(0xFFF84000)
+#define W90X900_PA_GDMA		(0xFFF03000)
+#define W90X900_PA_USBHOST	(0xFFF0d000)
+#define W90X900_PA_I2C		(0xFFF89000)
+#define W90X900_PA_LCD		(0xFFF06000)
+#define W90X900_PA_GE		(0xFFF05000)
+#define W90X900_PA_ADC		(0xFFF85000)
+#define W90X900_PA_RTC		(0xFFF87000)
+#define W90X900_PA_PWM		(0xFFF82000)
+#define W90X900_PA_ACTL		(0xFFF0a000)
+#define W90X900_PA_USBDEV	(0xFFF0C000)
+#define W90X900_PA_JEPEG	(0xFFF0e000)
+#define W90X900_PA_CACHE_T	(0xFFF60000)
+#define W90X900_PA_VRAM		(0xFFF0b000)
+#define W90X900_PA_DMAC		(0xFFF09000)
+#define W90X900_PA_I2SM		(0xFFF08000)
+#define W90X900_PA_CACHE	(0xFFF02000)
+#define W90X900_PA_GPU		(0xFFF04000)
+#define W90X900_PA_VIDEOIN	(0xFFF07000)
+#define W90X900_PA_SPI0		(0xFFF86000)
+#define W90X900_PA_SPI1		(0xFFF88000)
+
+/* USB host controller*/
+#define W90X900_VA_USBHOST	W90X900_ADDR(W90X900_PA_USBHOST)
+#define W90X900_SZ_USBHOST	SZ_4K
+
+#endif /* __ASM_ARCH_REG_H */
diff --git a/arch/arm/mach-w90x900/irq.c b/arch/arm/mach-w90x900/irq.c
index 0ce9d8e..5444a27 100644
--- a/arch/arm/mach-w90x900/irq.c
+++ b/arch/arm/mach-w90x900/irq.c
@@ -27,70 +27,7 @@
 
 #include <mach/hardware.h>
 #include <mach/regs-irq.h>
-
-struct group_irq {
-	unsigned long		gpen;
-	unsigned int		enabled;
-	void			(*enable)(struct group_irq *, int enable);
-};
-
-static DEFINE_SPINLOCK(groupirq_lock);
-
-#define DEFINE_GROUP(_name, _ctrlbit, _num)				\
-struct group_irq group_##_name = {					\
-		.enable		= nuc900_group_enable,			\
-		.gpen		= ((1 << _num) - 1) << _ctrlbit,	\
-	}
-
-static void nuc900_group_enable(struct group_irq *gpirq, int enable);
-
-static DEFINE_GROUP(nirq0, 0, 4);
-static DEFINE_GROUP(nirq1, 4, 4);
-static DEFINE_GROUP(usbh, 8, 2);
-static DEFINE_GROUP(ottimer, 16, 3);
-static DEFINE_GROUP(gdma, 20, 2);
-static DEFINE_GROUP(sc, 24, 2);
-static DEFINE_GROUP(i2c, 26, 2);
-static DEFINE_GROUP(ps2, 28, 2);
-
-static int group_irq_enable(struct group_irq *group_irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&groupirq_lock, flags);
-	if (group_irq->enabled++ == 0)
-		(group_irq->enable)(group_irq, 1);
-	spin_unlock_irqrestore(&groupirq_lock, flags);
-
-	return 0;
-}
-
-static void group_irq_disable(struct group_irq *group_irq)
-{
-	unsigned long flags;
-
-	WARN_ON(group_irq->enabled == 0);
-
-	spin_lock_irqsave(&groupirq_lock, flags);
-	if (--group_irq->enabled == 0)
-		(group_irq->enable)(group_irq, 0);
-	spin_unlock_irqrestore(&groupirq_lock, flags);
-}
-
-static void nuc900_group_enable(struct group_irq *gpirq, int enable)
-{
-	unsigned int groupen = gpirq->gpen;
-	unsigned long regval;
-
-	regval = __raw_readl(REG_AIC_GEN);
-
-	if (enable)
-		regval |= groupen;
-	else
-		regval &= ~groupen;
-
-	__raw_writel(regval, REG_AIC_GEN);
-}
+#include "groupirq.h"
 
 static void nuc900_irq_mask(unsigned int irq)
 {
@@ -100,42 +37,7 @@ static void nuc900_irq_mask(unsigned int irq)
 
 	__raw_writel(1 << irq, REG_AIC_MDCR);
 
-	switch (irq) {
-	case IRQ_GROUP0:
-		group_irq = &group_nirq0;
-		break;
-
-	case IRQ_GROUP1:
-		group_irq = &group_nirq1;
-		break;
-
-	case IRQ_USBH:
-		group_irq = &group_usbh;
-		break;
-
-	case IRQ_T_INT_GROUP:
-		group_irq = &group_ottimer;
-		break;
-
-	case IRQ_GDMAGROUP:
-		group_irq = &group_gdma;
-		break;
-
-	case IRQ_SCGROUP:
-		group_irq = &group_sc;
-		break;
-
-	case IRQ_I2CGROUP:
-		group_irq = &group_i2c;
-		break;
-
-	case IRQ_P2SGROUP:
-		group_irq = &group_ps2;
-		break;
-	}
-
-	if (group_irq)
-		group_irq_disable(group_irq);
+	nuc900_groupirq_mask(irq, 1);
 }
 
 /*
@@ -156,42 +58,7 @@ static void nuc900_irq_unmask(unsigned int irq)
 
 	__raw_writel(1 << irq, REG_AIC_MECR);
 
-	switch (irq) {
-	case IRQ_GROUP0:
-		group_irq = &group_nirq0;
-		break;
-
-	case IRQ_GROUP1:
-		group_irq = &group_nirq1;
-		break;
-
-	case IRQ_USBH:
-		group_irq = &group_usbh;
-		break;
-
-	case IRQ_T_INT_GROUP:
-		group_irq = &group_ottimer;
-		break;
-
-	case IRQ_GDMAGROUP:
-		group_irq = &group_gdma;
-		break;
-
-	case IRQ_SCGROUP:
-		group_irq = &group_sc;
-		break;
-
-	case IRQ_I2CGROUP:
-		group_irq = &group_i2c;
-		break;
-
-	case IRQ_P2SGROUP:
-		group_irq = &group_ps2;
-		break;
-	}
-
-	if (group_irq)
-		group_irq_enable(group_irq);
+	nuc900_groupirq_mask(irq, 0);
 }
 
 static struct irq_chip nuc900_irq_chip = {
diff --git a/arch/arm/mach-w90x900/mach-nuc932evb.c b/arch/arm/mach-w90x900/mach-nuc932evb.c
new file mode 100644
index 0000000..bcc67d2
--- /dev/null
+++ b/arch/arm/mach-w90x900/mach-nuc932evb.c
@@ -0,0 +1,42 @@
+/*
+ * linux/arch/arm/mach-w90x900/mach-nuc932evb.c
+ *
+ * Copyright (C) 2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach-types.h>
+#include <mach/map.h>
+
+#include "nuc932.h"
+
+static void __init nuc932evb_map_io(void)
+{
+	nuc932_map_io();
+	nuc932_init_clocks();
+}
+
+static void __init nuc932evb_init(void)
+{
+	nuc932_board_init();
+}
+
+MACHINE_START(NUC932EVB, "NUC932EVB")
+	/* Maintainer: Wan ZongShun */
+	.phys_io	= W90X900_PA_UART,
+	.io_pg_offst	= (((u32)W90X900_VA_UART) >> 18) & 0xfffc,
+	.boot_params	= 0,
+	.map_io		= nuc932evb_map_io,
+	.init_irq	= nuc900_init_irq,
+	.init_machine	= nuc932evb_init,
+	.timer		= &nuc900_timer,
+MACHINE_END
diff --git a/arch/arm/mach-w90x900/nuc910.c b/arch/arm/mach-w90x900/nuc910.c
index 656f03b..85d358f 100644
--- a/arch/arm/mach-w90x900/nuc910.c
+++ b/arch/arm/mach-w90x900/nuc910.c
@@ -19,7 +19,6 @@
 #include <asm/mach/map.h>
 #include <mach/hardware.h>
 #include "cpu.h"
-#include "clock.h"
 
 /* define specific CPU platform device */
 
@@ -49,7 +48,7 @@ void __init nuc910_map_io(void)
 
 void __init nuc910_init_clocks(void)
 {
-	nuc900_init_clocks();
+	nuc900_init_clocks(NULL, (size_t)NULL);
 }
 
 /*Init NUC910 board info*/
diff --git a/arch/arm/mach-w90x900/nuc932.c b/arch/arm/mach-w90x900/nuc932.c
new file mode 100644
index 0000000..6ad68aa
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc932.c
@@ -0,0 +1,54 @@
+/*
+ * linux/arch/arm/mach-w90x900/nuc932.c
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * NUC932 cpu support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <asm/mach/map.h>
+#include <mach/hardware.h>
+#include "cpu.h"
+
+static struct clk_lookup nuc932_clkregs[] = {
+};
+
+/* define specific CPU platform io map */
+
+static struct map_desc nuc932evb_iodesc[] __initdata = {
+};
+
+/*Init NUC932 evb io*/
+
+void __init nuc932_map_io(void)
+{
+	nuc900_map_io(nuc932evb_iodesc, ARRAY_SIZE(nuc932evb_iodesc));
+}
+
+/*Init NUC932 clock*/
+
+void __init nuc932_init_clocks(void)
+{
+	nuc900_init_clocks(nuc932_clkregs, ARRAY_SIZE(nuc932_clkregs));
+}
+
+/*Init NUC932 board info*/
+
+void __init nuc932_board_init(void)
+{
+	nuc932_dev_board_init();
+}
+
+/*NUC932 group irq api*/
+void nuc900_groupirq_mask(unsigned int irq, unsigned int mask)
+{
+}
+
diff --git a/arch/arm/mach-w90x900/nuc932.h b/arch/arm/mach-w90x900/nuc932.h
new file mode 100644
index 0000000..4cf1182
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc932.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm/mach-w90x900/nuc932.h
+ *
+ * Copyright (c) 2008 Nuvoton corporation
+ *
+ * Header file for NUC900 CPU support
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+struct map_desc;
+struct sys_timer;
+
+/* core initialisation functions */
+
+extern void nuc900_init_irq(void);
+extern struct sys_timer nuc900_timer;
+
+/* extern file from nuc932.c */
+
+extern void nuc932_board_init(void);
+extern void nuc932_init_clocks(void);
+extern void nuc932_map_io(void);
diff --git a/arch/arm/mach-w90x900/nuc950.c b/arch/arm/mach-w90x900/nuc950.c
index 1495081..9a4bc34 100644
--- a/arch/arm/mach-w90x900/nuc950.c
+++ b/arch/arm/mach-w90x900/nuc950.c
@@ -43,7 +43,7 @@ void __init nuc950_map_io(void)
 
 void __init nuc950_init_clocks(void)
 {
-	nuc900_init_clocks();
+	nuc900_init_clocks(NULL, (size_t)NULL);
 }
 
 /*Init NUC950 board info*/
diff --git a/arch/arm/mach-w90x900/nuc960.c b/arch/arm/mach-w90x900/nuc960.c
index 8851a3a..e523866 100644
--- a/arch/arm/mach-w90x900/nuc960.c
+++ b/arch/arm/mach-w90x900/nuc960.c
@@ -43,7 +43,7 @@ void __init nuc960_map_io(void)
 
 void __init nuc960_init_clocks(void)
 {
-	nuc900_init_clocks();
+	nuc900_init_clocks(NULL, (size_t)NULL);
 }
 
 /*Init NUC960 board info*/
diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
index 4128af8..34d8532 100644
--- a/arch/arm/mach-w90x900/time.c
+++ b/arch/arm/mach-w90x900/time.c
@@ -33,16 +33,7 @@
 #include <mach/map.h>
 #include <mach/regs-timer.h>
 
-#define RESETINT	0x1f
-#define PERIOD		(0x01 << 27)
-#define ONESHOT		(0x00 << 27)
-#define COUNTEN		(0x01 << 30)
-#define INTEN		(0x01 << 29)
-
-#define TICKS_PER_SEC	100
-#define PRESCALE	0x63 /* Divider = prescale + 1 */
-
-unsigned int timer0_load;
+#include "time.h"
 
 static void nuc900_clockevent_setmode(enum clock_event_mode mode,
 		struct clock_event_device *clk)
@@ -86,7 +77,7 @@ static int nuc900_clockevent_setnextevent(unsigned long evt,
 }
 
 static struct clock_event_device nuc900_clockevent_device = {
-	.name		= "nuc900-timer0",
+	.name		= TIME0NAME,
 	.shift		= 32,
 	.features	= CLOCK_EVT_MODE_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= nuc900_clockevent_setmode,
@@ -107,12 +98,12 @@ static irqreturn_t nuc900_timer0_interrupt(int irq, void *dev_id)
 }
 
 static struct irqaction nuc900_timer0_irq = {
-	.name		= "nuc900-timer0",
+	.name		= TIME0NAME,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= nuc900_timer0_interrupt,
 };
 
-static void __init nuc900_clockevents_init(unsigned int rate)
+static void nuc900_clockevents_init(unsigned int rate)
 {
 	nuc900_clockevent_device.mult = div_sc(rate, NSEC_PER_SEC,
 					nuc900_clockevent_device.shift);
@@ -125,58 +116,8 @@ static void __init nuc900_clockevents_init(unsigned int rate)
 	clockevents_register_device(&nuc900_clockevent_device);
 }
 
-static cycle_t nuc900_get_cycles(struct clocksource *cs)
+void nuc900_timer_init_clockevents(unsigned int rate)
 {
-	return ~__raw_readl(REG_TDR1);
-}
-
-static struct clocksource clocksource_nuc900 = {
-	.name	= "nuc900-timer1",
-	.rating	= 200,
-	.read	= nuc900_get_cycles,
-	.mask	= CLOCKSOURCE_MASK(32),
-	.shift	= 20,
-	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-static void __init nuc900_clocksource_init(unsigned int rate)
-{
-	unsigned int val;
-
-	__raw_writel(0xffffffff, REG_TICR1);
-
-	val = __raw_readl(REG_TCSR1);
-	val |= (COUNTEN | PERIOD);
-	__raw_writel(val, REG_TCSR1);
-
-	clocksource_nuc900.mult =
-		clocksource_khz2mult((rate / 1000), clocksource_nuc900.shift);
-	clocksource_register(&clocksource_nuc900);
-}
-
-static void __init nuc900_timer_init(void)
-{
-	struct clk *ck_ext = clk_get(NULL, "ext");
-	unsigned int	rate;
-
-	BUG_ON(IS_ERR(ck_ext));
-
-	rate = clk_get_rate(ck_ext);
-	clk_put(ck_ext);
-	rate = rate / (PRESCALE + 0x01);
-
-	 /* set a known state */
-	__raw_writel(0x00, REG_TCSR0);
-	__raw_writel(0x00, REG_TCSR1);
-	__raw_writel(RESETINT, REG_TISR);
-	timer0_load = (rate / TICKS_PER_SEC);
-
 	setup_irq(IRQ_TIMER0, &nuc900_timer0_irq);
-
-	nuc900_clocksource_init(rate);
 	nuc900_clockevents_init(rate);
 }
-
-struct sys_timer nuc900_timer = {
-	.init		= nuc900_timer_init,
-};
diff --git a/arch/arm/mach-w90x900/time.h b/arch/arm/mach-w90x900/time.h
new file mode 100644
index 0000000..cb52f34
--- /dev/null
+++ b/arch/arm/mach-w90x900/time.h
@@ -0,0 +1,33 @@
+/*
+ * arch/arm/mach-w90x900/time.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+#ifndef CONFIG_CPU_NUC932
+#define TIME0NAME	"nuc900-timer0"
+#define RESETINT	0x1f
+#else
+#define TIME0NAME	"nuc932-timer0"
+#define RESETINT	0x01
+#endif
+
+#define PERIOD		(0x01 << 27)
+#define ONESHOT		(0x00 << 27)
+#define COUNTEN		(0x01 << 30)
+#define INTEN		(0x01 << 29)
+
+#define TICKS_PER_SEC	100
+#define PRESCALE	0x63 /* Divider = prescale + 1 */
+
+static unsigned int timer0_load;
+extern void nuc900_timer_init_clockevents(unsigned int rate);
+
diff --git a/arch/arm/mach-w90x900/time_900.c b/arch/arm/mach-w90x900/time_900.c
new file mode 100644
index 0000000..d01c660
--- /dev/null
+++ b/arch/arm/mach-w90x900/time_900.c
@@ -0,0 +1,90 @@
+/*
+ * linux/arch/arm/mach-w90x900/time.c
+ *
+ * Based on linux/arch/arm/plat-s3c24xx/time.c by Ben Dooks
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/leds.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/time.h>
+
+#include <mach/map.h>
+#include <mach/regs-timer.h>
+
+#include "time.h"
+
+static cycle_t nuc900_get_cycles(struct clocksource *cs)
+{
+	return ~__raw_readl(REG_TDR1);
+}
+
+static struct clocksource clocksource_nuc900 = {
+	.name	= "nuc900-timer1",
+	.rating	= 200,
+	.read	= nuc900_get_cycles,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.shift	= 20,
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static void __init nuc900_clocksource_init(unsigned int rate)
+{
+	unsigned int val;
+
+	__raw_writel(0xffffffff, REG_TICR1);
+
+	val = __raw_readl(REG_TCSR1);
+	val |= (COUNTEN | PERIOD);
+	__raw_writel(val, REG_TCSR1);
+
+	clocksource_nuc900.mult =
+		clocksource_khz2mult((rate / 1000), clocksource_nuc900.shift);
+	clocksource_register(&clocksource_nuc900);
+}
+
+static void __init nuc900_timer_init(void)
+{
+	struct clk *ck_ext = clk_get(NULL, "ext");
+	unsigned int	rate;
+
+	BUG_ON(IS_ERR(ck_ext));
+
+	rate = clk_get_rate(ck_ext);
+	clk_put(ck_ext);
+	rate = rate / (PRESCALE + 0x01);
+
+	 /* set a known state */
+	__raw_writel(0x00, REG_TCSR0);
+	__raw_writel(0x00, REG_TCSR1);
+	__raw_writel(RESETINT, REG_TISR);
+	timer0_load = (rate / TICKS_PER_SEC);
+
+	nuc900_clocksource_init(rate);
+	nuc900_timer_init_clockevents(rate);
+}
+
+struct sys_timer nuc900_timer = {
+	.init		= nuc900_timer_init,
+};
diff --git a/arch/arm/mach-w90x900/time_932.c b/arch/arm/mach-w90x900/time_932.c
new file mode 100644
index 0000000..c50f9c0
--- /dev/null
+++ b/arch/arm/mach-w90x900/time_932.c
@@ -0,0 +1,59 @@
+/*
+ * linux/arch/arm/mach-w90x900/time.c
+ *
+ * Based on linux/arch/arm/plat-s3c24xx/time.c by Ben Dooks
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/leds.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/time.h>
+
+#include <mach/map.h>
+#include <mach/regs-timer.h>
+
+#include "time.h"
+
+static void __init nuc900_timer_init(void)
+{
+	struct clk *ck_ext = clk_get(NULL, "ext");
+	unsigned int	rate;
+
+	BUG_ON(IS_ERR(ck_ext));
+
+	rate = clk_get_rate(ck_ext);
+	clk_put(ck_ext);
+	rate = rate / (PRESCALE + 0x01);
+
+	 /* set a known state */
+	__raw_writel(0x00, REG_TCSR0);
+	__raw_writel(RESETINT, REG_TISR);
+	timer0_load = (rate / TICKS_PER_SEC);
+
+	nuc900_timer_init_clockevents(rate);
+}
+
+struct sys_timer nuc900_timer = {
+	.init		= nuc900_timer_init,
+};
-- 
1.5.6.3
   


--------------070107090203000901060708--
