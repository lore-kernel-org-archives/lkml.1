Return-Path: <linux-kernel-owner+w=401wt.eu-S1750976AbZLSJWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976AbZLSJWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 04:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZLSJWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 04:22:44 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49232 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZLSJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 04:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=j2zseGPNsGa5VdMQNDp//sZV7iqkar7NhVnMGkPVmuhLi6CJEyLh0emHnzHe5jsTfS
         ZL0DIAse6WC6BdS8b7xZyTE2SrmvKgskcer7BgbjhPSb3Lt4M46MPNOezszF9rGhGH6T
         SKuBAWVsvoizAEEcKZVBn0qmdX6HOJvq9Dxdw=
Message-ID: <4B2C9B51.2010904@gmail.com>
Date: Sat, 19 Dec 2009 17:22:25 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-arm-kerne <linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wan ZongShun <mcuos.com@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: Add  Winbond/Nuvoton NUC93X Platform support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

The previous nuc932 support patches have been discarded by me and 
because it belongs to
another SoCs series named nuc93x,at present, which included nuc931 and 
nuc932, I think it is
better to create a new mach-nuc93x,So I made the patch,and request your 
advice.Thanks!


Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/Kconfig                                |   11 ++
 arch/arm/Makefile                               |    1 +
 arch/arm/mach-nuc93x/Kconfig                    |   19 +++
 arch/arm/mach-nuc93x/Makefile                   |   14 +++
 arch/arm/mach-nuc93x/Makefile.boot              |    3 +
 arch/arm/mach-nuc93x/clock.c                    |   83 ++++++++++++++
 arch/arm/mach-nuc93x/clock.h                    |   36 ++++++
 arch/arm/mach-nuc93x/cpu.c                      |  135 
++++++++++++++++++++++
 arch/arm/mach-nuc93x/cpu.h                      |   48 ++++++++
 arch/arm/mach-nuc93x/dev.c                      |   42 +++++++
 arch/arm/mach-nuc93x/include/mach/clkdev.h      |    7 +
 arch/arm/mach-nuc93x/include/mach/entry-macro.S |   32 +++++
 arch/arm/mach-nuc93x/include/mach/hardware.h    |   22 ++++
 arch/arm/mach-nuc93x/include/mach/io.h          |   28 +++++
 arch/arm/mach-nuc93x/include/mach/irqs.h        |   59 ++++++++++
 arch/arm/mach-nuc93x/include/mach/map.h         |  139 
+++++++++++++++++++++++
 arch/arm/mach-nuc93x/include/mach/memory.h      |   21 ++++
 arch/arm/mach-nuc93x/include/mach/regs-clock.h  |   53 +++++++++
 arch/arm/mach-nuc93x/include/mach/regs-ebi.h    |   33 ++++++
 arch/arm/mach-nuc93x/include/mach/regs-irq.h    |   42 +++++++
 arch/arm/mach-nuc93x/include/mach/regs-serial.h |   52 +++++++++
 arch/arm/mach-nuc93x/include/mach/regs-timer.h  |   28 +++++
 arch/arm/mach-nuc93x/include/mach/system.h      |   28 +++++
 arch/arm/mach-nuc93x/include/mach/timex.h       |   25 ++++
 arch/arm/mach-nuc93x/include/mach/uncompress.h  |   50 ++++++++
 arch/arm/mach-nuc93x/include/mach/vmalloc.h     |   23 ++++
 arch/arm/mach-nuc93x/irq.c                      |   66 +++++++++++
 arch/arm/mach-nuc93x/mach-nuc932evb.c           |   45 ++++++++
 arch/arm/mach-nuc93x/nuc932.c                   |   65 +++++++++++
 arch/arm/mach-nuc93x/nuc932.h                   |   29 +++++
 arch/arm/mach-nuc93x/time.c                     |  100 ++++++++++++++++
 31 files changed, 1339 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-nuc93x/Kconfig
 create mode 100644 arch/arm/mach-nuc93x/Makefile
 create mode 100644 arch/arm/mach-nuc93x/Makefile.boot
 create mode 100644 arch/arm/mach-nuc93x/clock.c
 create mode 100644 arch/arm/mach-nuc93x/clock.h
 create mode 100644 arch/arm/mach-nuc93x/cpu.c
 create mode 100644 arch/arm/mach-nuc93x/cpu.h
 create mode 100644 arch/arm/mach-nuc93x/dev.c
 create mode 100644 arch/arm/mach-nuc93x/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-nuc93x/include/mach/hardware.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/io.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/irqs.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/map.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/memory.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/regs-clock.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/regs-ebi.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/regs-irq.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/regs-serial.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/regs-timer.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/system.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/timex.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-nuc93x/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-nuc93x/irq.c
 create mode 100644 arch/arm/mach-nuc93x/mach-nuc932evb.c
 create mode 100644 arch/arm/mach-nuc93x/nuc932.c
 create mode 100644 arch/arm/mach-nuc93x/nuc932.h
 create mode 100644 arch/arm/mach-nuc93x/time.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 233a222..79251a9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -548,6 +548,15 @@ config ARCH_W90X900
       <http://www.nuvoton.com/hq/enu/ProductAndSales/ProductLines/
         ConsumerElectronicsIC/ARMMicrocontroller/ARMMicrocontroller>
 
+config ARCH_NUC93X
+    bool "Nuvoton NUC93X CPU"
+    select CPU_ARM926T
+    select HAVE_CLK
+    select COMMON_CLKDEV
+    help
+      Support for Nuvoton (Winbond logic dept.) NUC93X MCU,The NUC93X is a
+      low-power and high performance MPEG-4/JPEG multimedia controller 
chip.
+
 config ARCH_PNX4008
     bool "Philips Nexperia PNX4008 Mobile"
     select CPU_ARM926T
@@ -828,6 +837,8 @@ source "arch/arm/mach-u300/Kconfig"
 
 source "arch/arm/mach-w90x900/Kconfig"
 
+source "arch/arm/mach-nuc93x/Kconfig"
+
 source "arch/arm/mach-bcmring/Kconfig"
 
 source "arch/arm/mach-ux500/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index e9da084..3eaef16 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -170,6 +170,7 @@ machine-$(CONFIG_ARCH_U300)        := u300
 machine-$(CONFIG_ARCH_U8500)        := ux500
 machine-$(CONFIG_ARCH_VERSATILE)    := versatile
 machine-$(CONFIG_ARCH_W90X900)        := w90x900
+machine-$(CONFIG_ARCH_NUC93X)        := nuc93x
 machine-$(CONFIG_FOOTBRIDGE)        := footbridge
 machine-$(CONFIG_ARCH_MXC91231)        := mxc91231
 
diff --git a/arch/arm/mach-nuc93x/Kconfig b/arch/arm/mach-nuc93x/Kconfig
new file mode 100644
index 0000000..2bc40a2
--- /dev/null
+++ b/arch/arm/mach-nuc93x/Kconfig
@@ -0,0 +1,19 @@
+if ARCH_NUC93X
+
+config CPU_NUC932
+    bool
+    help
+      Support for NUC932 of Nuvoton NUC93X CPUs.
+
+menu "NUC932 Machines"
+
+config MACH_NUC932EVB
+    bool "Nuvoton NUC932 Evaluation Board"
+    default y
+    select CPU_NUC932
+    help
+       Say Y here if you are using the Nuvoton NUC932EVB
+
+endmenu
+
+endif
diff --git a/arch/arm/mach-nuc93x/Makefile b/arch/arm/mach-nuc93x/Makefile
new file mode 100644
index 0000000..440e2de
--- /dev/null
+++ b/arch/arm/mach-nuc93x/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the linux kernel.
+#
+
+# Object file lists.
+
+obj-y                := irq.o time.o dev.o cpu.o clock.o
+# NUC932 CPU support files
+
+obj-$(CONFIG_CPU_NUC932)    += nuc932.o
+
+# machine support
+
+obj-$(CONFIG_MACH_NUC932EVB)    += mach-nuc932evb.o
diff --git a/arch/arm/mach-nuc93x/Makefile.boot 
b/arch/arm/mach-nuc93x/Makefile.boot
new file mode 100644
index 0000000..a057b54
--- /dev/null
+++ b/arch/arm/mach-nuc93x/Makefile.boot
@@ -0,0 +1,3 @@
+zreladdr-y    := 0x00008000
+params_phys-y    := 0x00000100
+
diff --git a/arch/arm/mach-nuc93x/clock.c b/arch/arm/mach-nuc93x/clock.c
new file mode 100644
index 0000000..0521efb
--- /dev/null
+++ b/arch/arm/mach-nuc93x/clock.c
@@ -0,0 +1,83 @@
+/*
+ * linux/arch/arm/mach-nuc93x/clock.c
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/clk.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#include <mach/hardware.h>
+
+#include "clock.h"
+
+static DEFINE_SPINLOCK(clocks_lock);
+
+int clk_enable(struct clk *clk)
+{
+    unsigned long flags;
+
+    spin_lock_irqsave(&clocks_lock, flags);
+    if (clk->enabled++ == 0)
+        (clk->enable)(clk, 1);
+    spin_unlock_irqrestore(&clocks_lock, flags);
+
+    return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+    unsigned long flags;
+
+    WARN_ON(clk->enabled == 0);
+
+    spin_lock_irqsave(&clocks_lock, flags);
+    if (--clk->enabled == 0)
+        (clk->enable)(clk, 0);
+    spin_unlock_irqrestore(&clocks_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+    return 27000000;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+void nuc93x_clk_enable(struct clk *clk, int enable)
+{
+    unsigned int clocks = clk->cken;
+    unsigned long clken;
+
+    clken = __raw_readl(NUC93X_VA_CLKPWR);
+
+    if (enable)
+        clken |= clocks;
+    else
+        clken &= ~clocks;
+
+    __raw_writel(clken, NUC93X_VA_CLKPWR);
+}
+
+void clks_register(struct clk_lookup *clks, size_t num)
+{
+    int i;
+
+    for (i = 0; i < num; i++)
+        clkdev_add(&clks[i]);
+}
diff --git a/arch/arm/mach-nuc93x/clock.h b/arch/arm/mach-nuc93x/clock.h
new file mode 100644
index 0000000..18e51be
--- /dev/null
+++ b/arch/arm/mach-nuc93x/clock.h
@@ -0,0 +1,36 @@
+/*
+ * linux/arch/arm/mach-nuc93x/clock.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+
+#include <asm/clkdev.h>
+
+void nuc93x_clk_enable(struct clk *clk, int enable);
+void clks_register(struct clk_lookup *clks, size_t num);
+
+struct clk {
+    unsigned long        cken;
+    unsigned int        enabled;
+    void            (*enable)(struct clk *, int enable);
+};
+
+#define DEFINE_CLK(_name, _ctrlbit)            \
+struct clk clk_##_name = {                \
+        .enable    = nuc93x_clk_enable,        \
+        .cken    = (1 << _ctrlbit),        \
+    }
+
+#define DEF_CLKLOOK(_clk, _devname, _conname)        \
+    {                        \
+        .clk        = _clk,            \
+        .dev_id        = _devname,        \
+        .con_id        = _conname,        \
+    }
+
diff --git a/arch/arm/mach-nuc93x/cpu.c b/arch/arm/mach-nuc93x/cpu.c
new file mode 100644
index 0000000..f6ff5d8
--- /dev/null
+++ b/arch/arm/mach-nuc93x/cpu.c
@@ -0,0 +1,135 @@
+/*
+ * linux/arch/arm/mach-nuc93x/cpu.c
+ *
+ * Copyright (c) 2009 Nuvoton corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * NUC93x series cpu common support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
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
+#include <linux/io.h>
+#include <linux/serial_8250.h>
+#include <linux/delay.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/irq.h>
+
+#include <mach/hardware.h>
+#include <mach/regs-serial.h>
+#include <mach/regs-clock.h>
+#include <mach/regs-ebi.h>
+
+#include "cpu.h"
+#include "clock.h"
+
+/* Initial IO mappings */
+
+static struct map_desc nuc93x_iodesc[] __initdata = {
+    IODESC_ENT(IRQ),
+    IODESC_ENT(GCR),
+    IODESC_ENT(UART),
+    IODESC_ENT(TIMER),
+    IODESC_ENT(EBI),
+};
+
+/* Initial nuc932 clock declarations. */
+static DEFINE_CLK(audio, 2);
+static DEFINE_CLK(sd, 3);
+static DEFINE_CLK(jpg, 4);
+static DEFINE_CLK(video, 5);
+static DEFINE_CLK(vpost, 6);
+static DEFINE_CLK(2d, 7);
+static DEFINE_CLK(gpu, 8);
+static DEFINE_CLK(gdma, 9);
+static DEFINE_CLK(adc, 10);
+static DEFINE_CLK(uart, 11);
+static DEFINE_CLK(spi, 12);
+static DEFINE_CLK(pwm, 13);
+static DEFINE_CLK(timer, 14);
+static DEFINE_CLK(wdt, 15);
+static DEFINE_CLK(ac97, 16);
+static DEFINE_CLK(i2s, 16);
+static DEFINE_CLK(usbck, 17);
+static DEFINE_CLK(usb48, 18);
+static DEFINE_CLK(usbh, 19);
+static DEFINE_CLK(i2c, 20);
+static DEFINE_CLK(ext, 0);
+
+static struct clk_lookup nuc932_clkregs[] = {
+       DEF_CLKLOOK(&clk_audio, "nuc932-audio", NULL),
+       DEF_CLKLOOK(&clk_sd, "nuc932-sd", NULL),
+       DEF_CLKLOOK(&clk_jpg, "nuc932-jpg", "NULL"),
+       DEF_CLKLOOK(&clk_video, "nuc932-video", "NULL"),
+       DEF_CLKLOOK(&clk_vpost, "nuc932-vpost", NULL),
+       DEF_CLKLOOK(&clk_2d, "nuc932-2d", NULL),
+       DEF_CLKLOOK(&clk_gpu, "nuc932-gpu", NULL),
+       DEF_CLKLOOK(&clk_gdma, "nuc932-gdma", "NULL"),
+       DEF_CLKLOOK(&clk_adc, "nuc932-adc", NULL),
+       DEF_CLKLOOK(&clk_uart, NULL, "uart"),
+       DEF_CLKLOOK(&clk_spi, "nuc932-spi", NULL),
+       DEF_CLKLOOK(&clk_pwm, "nuc932-pwm", NULL),
+       DEF_CLKLOOK(&clk_timer, NULL, "timer"),
+       DEF_CLKLOOK(&clk_wdt, "nuc932-wdt", NULL),
+       DEF_CLKLOOK(&clk_ac97, "nuc932-ac97", NULL),
+       DEF_CLKLOOK(&clk_i2s, "nuc932-i2s", NULL),
+       DEF_CLKLOOK(&clk_usbck, "nuc932-usbck", NULL),
+       DEF_CLKLOOK(&clk_usb48, "nuc932-usb48", NULL),
+       DEF_CLKLOOK(&clk_usbh, "nuc932-usbh", NULL),
+       DEF_CLKLOOK(&clk_i2c, "nuc932-i2c", NULL),
+       DEF_CLKLOOK(&clk_ext, NULL, "ext"),
+};
+
+/* Initial serial platform data */
+
+struct plat_serial8250_port nuc93x_uart_data[] = {
+    NUC93X_8250PORT(UART0),
+    {},
+};
+
+struct platform_device nuc93x_serial_device = {
+    .name            = "serial8250",
+    .id            = PLAT8250_DEV_PLATFORM,
+    .dev            = {
+        .platform_data    = nuc93x_uart_data,
+    },
+};
+
+/*Init NUC93x evb io*/
+
+void __init nuc93x_map_io(struct map_desc *mach_desc, int mach_size)
+{
+    unsigned long idcode = 0x0;
+
+    iotable_init(mach_desc, mach_size);
+    iotable_init(nuc93x_iodesc, ARRAY_SIZE(nuc93x_iodesc));
+
+    idcode = __raw_readl(NUC93XPDID);
+    if (idcode == NUC932_CPUID)
+        printk(KERN_INFO "CPU type 0x%08lx is NUC910\n", idcode);
+    else
+        printk(KERN_ERR "CPU type detect error!\n");
+
+}
+
+/*Init NUC93x clock*/
+
+void __init nuc93x_init_clocks(void)
+{
+    clks_register(nuc932_clkregs, ARRAY_SIZE(nuc932_clkregs));
+}
+
diff --git a/arch/arm/mach-nuc93x/cpu.h b/arch/arm/mach-nuc93x/cpu.h
new file mode 100644
index 0000000..9def281
--- /dev/null
+++ b/arch/arm/mach-nuc93x/cpu.h
@@ -0,0 +1,48 @@
+/*
+ * arch/arm/mach-nuc93x/cpu.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Header file for NUC93X CPU support
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define IODESC_ENT(y)                    \
+{                            \
+    .virtual = (unsigned long)NUC93X_VA_##y,    \
+    .pfn     = __phys_to_pfn(NUC93X_PA_##y),    \
+    .length  = NUC93X_SZ_##y,            \
+    .type    = MT_DEVICE,                \
+}
+
+#define NUC93X_8250PORT(name)                    \
+{                                \
+    .membase    = name##_BA,                \
+    .mapbase    = name##_PA,                \
+    .irq        = IRQ_##name,                \
+    .uartclk    = 57139200,                \
+    .regshift    = 2,                    \
+    .iotype        = UPIO_MEM,                \
+    .flags        = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,    \
+}
+
+/*Cpu identifier register*/
+
+#define NUC93XPDID    NUC93X_VA_GCR
+#define NUC932_CPUID    0x29550091
+
+/* extern file from cpu.c */
+
+extern void nuc93x_clock_source(struct device *dev, unsigned char *src);
+extern void nuc93x_init_clocks(void);
+extern void nuc93x_map_io(struct map_desc *mach_desc, int mach_size);
+extern void nuc93x_board_init(struct platform_device **device, int size);
+extern struct platform_device nuc93x_serial_device;
+
diff --git a/arch/arm/mach-nuc93x/dev.c b/arch/arm/mach-nuc93x/dev.c
new file mode 100644
index 0000000..a962ae9
--- /dev/null
+++ b/arch/arm/mach-nuc93x/dev.c
@@ -0,0 +1,42 @@
+/*
+ * linux/arch/arm/mach-nuc93x/dev.c
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
+#include "cpu.h"
+
+/*Here should be your evb resourse,such as LCD*/
+
+static struct platform_device *nuc93x_public_dev[] __initdata = {
+    &nuc93x_serial_device,
+};
+
+/* Provide adding specific CPU platform devices API */
+
+void __init nuc93x_board_init(struct platform_device **device, int size)
+{
+    platform_add_devices(device, size);
+    platform_add_devices(nuc93x_public_dev, ARRAY_SIZE(nuc93x_public_dev));
+}
+
diff --git a/arch/arm/mach-nuc93x/include/mach/clkdev.h 
b/arch/arm/mach-nuc93x/include/mach/clkdev.h
new file mode 100644
index 0000000..04b37a8
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/clkdev.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+
+#endif
diff --git a/arch/arm/mach-nuc93x/include/mach/entry-macro.S 
b/arch/arm/mach-nuc93x/include/mach/entry-macro.S
new file mode 100644
index 0000000..1352cbd
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/entry-macro.S
@@ -0,0 +1,32 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/entry-macro.S
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ */
+
+#include <mach/hardware.h>
+#include <mach/regs-irq.h>
+
+    .macro  get_irqnr_preamble, base, tmp
+    .endm
+
+    .macro  arch_ret_to_user, tmp1, tmp2
+    .endm
+
+    .macro    get_irqnr_and_base, irqnr, irqstat, base, tmp
+
+        mov    \base, #AIC_BA
+
+        ldr    \irqnr, [ \base, #AIC_IPER]
+        ldr    \irqnr, [ \base, #AIC_ISNR]
+        cmp    \irqnr, #0
+
+    .endm
+
+    /* currently don't need an disable_fiq macro */
+
+    .macro    disable_fiq
+    .endm
diff --git a/arch/arm/mach-nuc93x/include/mach/hardware.h 
b/arch/arm/mach-nuc93x/include/mach/hardware.h
new file mode 100644
index 0000000..fb5c6fc
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/hardware.h
@@ -0,0 +1,22 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/hardware.h
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
+#ifndef __ASM_ARCH_HARDWARE_H
+#define __ASM_ARCH_HARDWARE_H
+
+#include <asm/sizes.h>
+#include <mach/map.h>
+
+#endif /* __ASM_ARCH_HARDWARE_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/io.h 
b/arch/arm/mach-nuc93x/include/mach/io.h
new file mode 100644
index 0000000..72e5051
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/io.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/io.h
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
+#ifndef __ASM_ARM_ARCH_IO_H
+#define __ASM_ARM_ARCH_IO_H
+
+#define IO_SPACE_LIMIT    0xffffffff
+
+/*
+ * 1:1 mapping for ioremapped regions.
+ */
+
+#define __mem_pci(a)    (a)
+#define __io(a)        __typesafe_io(a)
+
+#endif
diff --git a/arch/arm/mach-nuc93x/include/mach/irqs.h 
b/arch/arm/mach-nuc93x/include/mach/irqs.h
new file mode 100644
index 0000000..7c4aa71
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/irqs.h
@@ -0,0 +1,59 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/irqs.h
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
+#ifndef __ASM_ARCH_IRQS_H
+#define __ASM_ARCH_IRQS_H
+
+#define NUC93X_IRQ(x)    (x)
+
+/* Main cpu interrupts */
+
+#define IRQ_WDT        NUC93X_IRQ(1)
+#define IRQ_IRQ0    NUC93X_IRQ(2)
+#define IRQ_IRQ1    NUC93X_IRQ(3)
+#define IRQ_IRQ2    NUC93X_IRQ(4)
+#define IRQ_IRQ3    NUC93X_IRQ(5)
+#define IRQ_USBH    NUC93X_IRQ(6)
+#define IRQ_APU        NUC93X_IRQ(7)
+#define IRQ_VPOST    NUC93X_IRQ(8)
+#define IRQ_ADC        NUC93X_IRQ(9)
+#define IRQ_UART0    NUC93X_IRQ(10)
+#define IRQ_TIMER0    NUC93X_IRQ(11)
+#define IRQ_GPU0    NUC93X_IRQ(12)
+#define IRQ_GPU1    NUC93X_IRQ(13)
+#define IRQ_GPU2    NUC93X_IRQ(14)
+#define IRQ_GPU3    NUC93X_IRQ(15)
+#define IRQ_GPU4    NUC93X_IRQ(16)
+#define IRQ_VIN        NUC93X_IRQ(17)
+#define IRQ_USBD    NUC93X_IRQ(18)
+#define IRQ_VRAMLD    NUC93X_IRQ(19)
+#define IRQ_GDMA0    NUC93X_IRQ(20)
+#define IRQ_GDMA1    NUC93X_IRQ(21)
+#define IRQ_SDIO    NUC93X_IRQ(22)
+#define IRQ_FMI        NUC93X_IRQ(22)
+#define IRQ_JPEG    NUC93X_IRQ(23)
+#define IRQ_SPI0    NUC93X_IRQ(24)
+#define IRQ_SPI1    NUC93X_IRQ(25)
+#define IRQ_RTC        NUC93X_IRQ(26)
+#define IRQ_PWM0    NUC93X_IRQ(27)
+#define IRQ_PWM1    NUC93X_IRQ(28)
+#define IRQ_PWM2    NUC93X_IRQ(29)
+#define IRQ_PWM3    NUC93X_IRQ(30)
+#define IRQ_I2SAC97    NUC93X_IRQ(31)
+#define IRQ_CAP0    IRQ_PWM0
+#define IRQ_CAP1    IRQ_PWM1
+#define IRQ_CAP2    IRQ_PWM2
+#define IRQ_CAP3    IRQ_PWM3
+#define NR_IRQS        (IRQ_I2SAC97 + 1)
+
+#endif /* __ASM_ARCH_IRQ_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/map.h 
b/arch/arm/mach-nuc93x/include/mach/map.h
new file mode 100644
index 0000000..fd0b5e8
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/map.h
@@ -0,0 +1,139 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/map.h
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
+#ifndef __ASM_ARCH_MAP_H
+#define __ASM_ARCH_MAP_H
+
+#define MAP_OFFSET    (0xfff00000)
+#define CLK_OFFSET    (0x10)
+
+#ifndef __ASSEMBLY__
+#define NUC93X_ADDR(x)    ((void __iomem *)(0xF0000000 + 
((x)&(~MAP_OFFSET))))
+#else
+#define NUC93X_ADDR(x)    (0xF0000000 + ((x)&(~MAP_OFFSET)))
+#endif
+
+ /*
+  * nuc932 hardware register definition
+  */
+
+#define NUC93X_PA_IRQ        (0xFFF83000)
+#define NUC93X_PA_GCR        (0xFFF00000)
+#define NUC93X_PA_EBI        (0xFFF01000)
+#define NUC93X_PA_UART        (0xFFF80000)
+#define NUC93X_PA_TIMER        (0xFFF81000)
+#define NUC93X_PA_GPIO        (0xFFF84000)
+#define NUC93X_PA_GDMA        (0xFFF03000)
+#define NUC93X_PA_USBHOST    (0xFFF0d000)
+#define NUC93X_PA_I2C        (0xFFF89000)
+#define NUC93X_PA_LCD        (0xFFF06000)
+#define NUC93X_PA_GE        (0xFFF05000)
+#define NUC93X_PA_ADC        (0xFFF85000)
+#define NUC93X_PA_RTC        (0xFFF87000)
+#define NUC93X_PA_PWM        (0xFFF82000)
+#define NUC93X_PA_ACTL        (0xFFF0a000)
+#define NUC93X_PA_USBDEV    (0xFFF0C000)
+#define NUC93X_PA_JEPEG        (0xFFF0e000)
+#define NUC93X_PA_CACHE_T    (0xFFF60000)
+#define NUC93X_PA_VRAM        (0xFFF0b000)
+#define NUC93X_PA_DMAC        (0xFFF09000)
+#define NUC93X_PA_I2SM        (0xFFF08000)
+#define NUC93X_PA_CACHE        (0xFFF02000)
+#define NUC93X_PA_GPU        (0xFFF04000)
+#define NUC93X_PA_VIDEOIN    (0xFFF07000)
+#define NUC93X_PA_SPI0        (0xFFF86000)
+#define NUC93X_PA_SPI1        (0xFFF88000)
+
+ /*
+  * nuc932 virtual address mapping.
+  * interrupt controller is the first thing we put in, to make
+  * the assembly code for the irq detection easier
+  */
+
+#define NUC93X_VA_IRQ        NUC93X_ADDR(0x00000000)
+#define NUC93X_SZ_IRQ        SZ_4K
+
+#define NUC93X_VA_GCR        NUC93X_ADDR(NUC93X_PA_IRQ)
+#define NUC93X_VA_CLKPWR    (NUC93X_VA_GCR+CLK_OFFSET)
+#define NUC93X_SZ_GCR        SZ_4K
+
+/* EBI management */
+
+#define NUC93X_VA_EBI        NUC93X_ADDR(NUC93X_PA_EBI)
+#define NUC93X_SZ_EBI        SZ_4K
+
+/* UARTs */
+
+#define NUC93X_VA_UART        NUC93X_ADDR(NUC93X_PA_UART)
+#define NUC93X_SZ_UART        SZ_4K
+
+/* Timers */
+
+#define NUC93X_VA_TIMER    NUC93X_ADDR(NUC93X_PA_TIMER)
+#define NUC93X_SZ_TIMER    SZ_4K
+
+/* GPIO ports */
+
+#define NUC93X_VA_GPIO        NUC93X_ADDR(NUC93X_PA_GPIO)
+#define NUC93X_SZ_GPIO        SZ_4K
+
+/* GDMA control */
+
+#define NUC93X_VA_GDMA        NUC93X_ADDR(NUC93X_PA_GDMA)
+#define NUC93X_SZ_GDMA        SZ_4K
+
+/* I2C hardware controller */
+
+#define NUC93X_VA_I2C        NUC93X_ADDR(NUC93X_PA_I2C)
+#define NUC93X_SZ_I2C        SZ_4K
+
+/* LCD controller*/
+
+#define NUC93X_VA_LCD        NUC93X_ADDR(NUC93X_PA_LCD)
+#define NUC93X_SZ_LCD        SZ_4K
+
+/* 2D controller*/
+
+#define NUC93X_VA_GE        NUC93X_ADDR(NUC93X_PA_GE)
+#define NUC93X_SZ_GE        SZ_4K
+
+/* ADC */
+
+#define NUC93X_VA_ADC        NUC93X_ADDR(NUC93X_PA_ADC)
+#define NUC93X_SZ_ADC        SZ_4K
+
+/* RTC */
+
+#define NUC93X_VA_RTC        NUC93X_ADDR(NUC93X_PA_RTC)
+#define NUC93X_SZ_RTC        SZ_4K
+
+/* Pulse Width Modulation(PWM) Registers */
+
+#define NUC93X_VA_PWM        NUC93X_ADDR(NUC93X_PA_PWM)
+#define NUC93X_SZ_PWM        SZ_4K
+
+/* Audio Controller controller */
+
+#define NUC93X_VA_ACTL        NUC93X_ADDR(NUC93X_PA_ACTL)
+#define NUC93X_SZ_ACTL        SZ_4K
+
+/* USB Device port */
+
+#define NUC93X_VA_USBDEV    NUC93X_ADDR(NUC93X_PA_USBDEV)
+#define NUC93X_SZ_USBDEV    SZ_4K
+
+/* USB host controller*/
+#define NUC93X_VA_USBHOST    NUC93X_ADDR(NUC93X_PA_USBHOST)
+#define NUC93X_SZ_USBHOST    SZ_4K
+
+#endif /* __ASM_ARCH_MAP_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/memory.h 
b/arch/arm/mach-nuc93x/include/mach/memory.h
new file mode 100644
index 0000000..323ab0d
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/memory.h
@@ -0,0 +1,21 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/memory.h
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
+#ifndef __ASM_ARCH_MEMORY_H
+#define __ASM_ARCH_MEMORY_H
+
+#define PHYS_OFFSET    UL(0x00000000)
+
+#endif
diff --git a/arch/arm/mach-nuc93x/include/mach/regs-clock.h 
b/arch/arm/mach-nuc93x/include/mach/regs-clock.h
new file mode 100644
index 0000000..5cb2954
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/regs-clock.h
@@ -0,0 +1,53 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/regs-clock.h
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
+#ifndef __ASM_ARCH_REGS_CLOCK_H
+#define __ASM_ARCH_REGS_CLOCK_H
+
+/* Clock Control Registers  */
+#define CLK_BA        NUC93X_VA_CLKPWR
+#define REG_CLKEN    (CLK_BA + 0x00)
+#define REG_CLKSEL    (CLK_BA + 0x04)
+#define REG_CLKDIV    (CLK_BA + 0x08)
+#define REG_PLLCON0    (CLK_BA + 0x0C)
+#define REG_PLLCON1    (CLK_BA + 0x10)
+#define REG_PMCON    (CLK_BA + 0x14)
+#define REG_IRQWAKECON    (CLK_BA + 0x18)
+#define REG_IRQWAKEFLAG    (CLK_BA + 0x1C)
+#define REG_IPSRST    (CLK_BA + 0x20)
+#define REG_CLKEN1    (CLK_BA + 0x24)
+#define REG_CLKDIV1    (CLK_BA + 0x28)
+
+/* Define PLL freq setting */
+#define PLL_DISABLE        0x12B63
+#define    PLL_66MHZ        0x2B63
+#define    PLL_100MHZ        0x4F64
+#define PLL_120MHZ        0x4F63
+#define    PLL_166MHZ        0x4124
+#define    PLL_200MHZ        0x4F24
+
+/* Define AHB:CPUFREQ ratio */
+#define    AHB_CPUCLK_1_1        0x00
+#define    AHB_CPUCLK_1_2        0x01
+#define    AHB_CPUCLK_1_4        0x02
+#define    AHB_CPUCLK_1_8        0x03
+
+/* Define APB:AHB ratio */
+#define APB_AHB_1_2        0x01
+#define APB_AHB_1_4        0x02
+#define APB_AHB_1_8        0x03
+
+/* Define clock skew */
+#define DEFAULTSKEW        0x48
+
+#endif /*  __ASM_ARCH_REGS_CLOCK_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/regs-ebi.h 
b/arch/arm/mach-nuc93x/include/mach/regs-ebi.h
new file mode 100644
index 0000000..3c72550
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/regs-ebi.h
@@ -0,0 +1,33 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/regs-ebi.h
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#ifndef __ASM_ARCH_REGS_EBI_H
+#define __ASM_ARCH_REGS_EBI_H
+
+/* EBI Control Registers */
+
+#define EBI_BA        NUC93X_VA_EBI
+#define REG_EBICON    (EBI_BA + 0x00)
+#define REG_ROMCON    (EBI_BA + 0x04)
+#define REG_SDCONF0    (EBI_BA + 0x08)
+#define REG_SDCONF1    (EBI_BA + 0x0C)
+#define REG_SDTIME0    (EBI_BA + 0x10)
+#define REG_SDTIME1    (EBI_BA + 0x14)
+#define REG_EXT0CON    (EBI_BA + 0x18)
+#define REG_EXT1CON    (EBI_BA + 0x1C)
+#define REG_EXT2CON    (EBI_BA + 0x20)
+#define REG_EXT3CON    (EBI_BA + 0x24)
+#define REG_EXT4CON    (EBI_BA + 0x28)
+#define REG_CKSKEW    (EBI_BA + 0x2C)
+
+#endif /*  __ASM_ARCH_REGS_EBI_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/regs-irq.h 
b/arch/arm/mach-nuc93x/include/mach/regs-irq.h
new file mode 100644
index 0000000..2302159
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/regs-irq.h
@@ -0,0 +1,42 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/regs-irq.h
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
+#ifndef ___ASM_ARCH_REGS_IRQ_H
+#define ___ASM_ARCH_REGS_IRQ_H
+
+/* Advance Interrupt Controller (AIC) Registers */
+
+#define AIC_BA            NUC93X_VA_IRQ
+
+#define REG_AIC_IRQSC        (AIC_BA+0x80)
+#define REG_AIC_GEN        (AIC_BA+0x84)
+#define REG_AIC_GASR        (AIC_BA+0x88)
+#define REG_AIC_GSCR        (AIC_BA+0x8C)
+#define REG_AIC_IRSR        (AIC_BA+0x100)
+#define REG_AIC_IASR        (AIC_BA+0x104)
+#define REG_AIC_ISR        (AIC_BA+0x108)
+#define REG_AIC_IPER        (AIC_BA+0x10C)
+#define REG_AIC_ISNR        (AIC_BA+0x110)
+#define REG_AIC_IMR        (AIC_BA+0x114)
+#define REG_AIC_OISR        (AIC_BA+0x118)
+#define REG_AIC_MECR        (AIC_BA+0x120)
+#define REG_AIC_MDCR        (AIC_BA+0x124)
+#define REG_AIC_SSCR        (AIC_BA+0x128)
+#define REG_AIC_SCCR        (AIC_BA+0x12C)
+#define REG_AIC_EOSCR        (AIC_BA+0x130)
+#define AIC_IPER        (0x10C)
+#define AIC_ISNR        (0x110)
+
+#endif /* ___ASM_ARCH_REGS_IRQ_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/regs-serial.h 
b/arch/arm/mach-nuc93x/include/mach/regs-serial.h
new file mode 100644
index 0000000..767a047
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/regs-serial.h
@@ -0,0 +1,52 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/regs-serial.h
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
+#ifndef __ASM_ARM_REGS_SERIAL_H
+#define __ASM_ARM_REGS_SERIAL_H
+
+#define UART0_BA    NUC93X_VA_UART
+#define UART1_BA    (NUC93X_VA_UART+0x100)
+
+#define UART0_PA    NUC93X_PA_UART
+#define UART1_PA    (NUC93X_PA_UART+0x100)
+
+
+#ifndef __ASSEMBLY__
+
+struct nuc93x_uart_clksrc {
+    const char    *name;
+    unsigned int    divisor;
+    unsigned int    min_baud;
+    unsigned int    max_baud;
+};
+
+struct nuc93x_uartcfg {
+    unsigned char    hwport;
+    unsigned char    unused;
+    unsigned short    flags;
+    unsigned long    uart_flags;
+
+    unsigned long    ucon;
+    unsigned long    ulcon;
+    unsigned long    ufcon;
+
+    struct nuc93x_uart_clksrc *clocks;
+    unsigned int    clocks_size;
+};
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __ASM_ARM_REGS_SERIAL_H */
+
diff --git a/arch/arm/mach-nuc93x/include/mach/regs-timer.h 
b/arch/arm/mach-nuc93x/include/mach/regs-timer.h
new file mode 100644
index 0000000..394be96
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/regs-timer.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/regs-timer.h
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
+#ifndef __ASM_ARCH_REGS_TIMER_H
+#define __ASM_ARCH_REGS_TIMER_H
+
+/* Timer Registers */
+
+#define TMR_BA            NUC93X_VA_TIMER
+#define REG_TCSR0        (TMR_BA+0x00)
+#define REG_TICR0        (TMR_BA+0x08)
+#define REG_TDR0        (TMR_BA+0x10)
+#define REG_TISR        (TMR_BA+0x18)
+#define REG_WTCR        (TMR_BA+0x1C)
+
+#endif /*  __ASM_ARCH_REGS_TIMER_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/system.h 
b/arch/arm/mach-nuc93x/include/mach/system.h
new file mode 100644
index 0000000..d26bd9a
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/system.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm/machnuc93x/include/mach/system.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * Based on arch/arm/mach-s3c2410/include/mach/system.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <asm/proc-fns.h>
+
+static void arch_idle(void)
+{
+}
+
+static void arch_reset(char mode, const char *cmd)
+{
+    cpu_reset(0);
+}
+
diff --git a/arch/arm/mach-nuc93x/include/mach/timex.h 
b/arch/arm/mach-nuc93x/include/mach/timex.h
new file mode 100644
index 0000000..0c719cc
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/timex.h
@@ -0,0 +1,25 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/timex.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * Based on arch/arm/mach-s3c2410/include/mach/timex.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef __ASM_ARCH_TIMEX_H
+#define __ASM_ARCH_TIMEX_H
+
+/* CLOCK_TICK_RATE Now, I don't use it. */
+
+#define CLOCK_TICK_RATE 27000000
+
+#endif /* __ASM_ARCH_TIMEX_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/uncompress.h 
b/arch/arm/mach-nuc93x/include/mach/uncompress.h
new file mode 100644
index 0000000..73082cd
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/uncompress.h
@@ -0,0 +1,50 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/uncompress.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * Based on arch/arm/mach-s3c2410/include/mach/uncompress.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef __ASM_ARCH_UNCOMPRESS_H
+#define __ASM_ARCH_UNCOMPRESS_H
+
+/* Defines for UART registers */
+
+#include <mach/regs-serial.h>
+#include <mach/map.h>
+#include <linux/serial_reg.h>
+
+#define arch_decomp_wdog()
+
+#define TX_DONE    (UART_LSR_TEMT | UART_LSR_THRE)
+static u32 * uart_base = (u32 *)UART0_PA;
+
+static void putc(int ch)
+{
+    /* Check THRE and TEMT bits before we transmit the character.
+     */
+    while ((uart_base[UART_LSR] & TX_DONE) != TX_DONE)
+        barrier();
+
+    *uart_base = ch;
+}
+
+static inline void flush(void)
+{
+}
+
+static void arch_decomp_setup(void)
+{
+}
+
+#endif/* __ASM_NUC93X_UNCOMPRESS_H */
diff --git a/arch/arm/mach-nuc93x/include/mach/vmalloc.h 
b/arch/arm/mach-nuc93x/include/mach/vmalloc.h
new file mode 100644
index 0000000..98a21b8
--- /dev/null
+++ b/arch/arm/mach-nuc93x/include/mach/vmalloc.h
@@ -0,0 +1,23 @@
+/*
+ * arch/arm/mach-nuc93x/include/mach/vmalloc.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * Based on arch/arm/mach-s3c2410/include/mach/vmalloc.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef __ASM_ARCH_VMALLOC_H
+#define __ASM_ARCH_VMALLOC_H
+
+#define VMALLOC_END      (0xE0000000)
+
+#endif /* __ASM_ARCH_VMALLOC_H */
diff --git a/arch/arm/mach-nuc93x/irq.c b/arch/arm/mach-nuc93x/irq.c
new file mode 100644
index 0000000..a7a88ea
--- /dev/null
+++ b/arch/arm/mach-nuc93x/irq.c
@@ -0,0 +1,66 @@
+/*
+ * linux/arch/arm/mach-nuc93x/irq.c
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
+static void nuc93x_irq_mask(unsigned int irq)
+{
+    __raw_writel(1 << irq, REG_AIC_MDCR);
+}
+
+/*
+ * By the w90p910 spec,any irq,only write 1
+ * to REG_AIC_EOSCR for ACK
+ */
+
+static void nuc93x_irq_ack(unsigned int irq)
+{
+    __raw_writel(0x01, REG_AIC_EOSCR);
+}
+
+static void nuc93x_irq_unmask(unsigned int irq)
+{
+    __raw_writel(1 << irq, REG_AIC_MECR);
+
+}
+
+static struct irq_chip nuc93x_irq_chip = {
+    .ack       = nuc93x_irq_ack,
+    .mask       = nuc93x_irq_mask,
+    .unmask       = nuc93x_irq_unmask,
+};
+
+void __init nuc93x_init_irq(void)
+{
+    int irqno;
+
+    __raw_writel(0xFFFFFFFE, REG_AIC_MDCR);
+
+    for (irqno = IRQ_WDT; irqno <= NR_IRQS; irqno++) {
+        set_irq_chip(irqno, &nuc93x_irq_chip);
+        set_irq_handler(irqno, handle_level_irq);
+        set_irq_flags(irqno, IRQF_VALID);
+    }
+}
diff --git a/arch/arm/mach-nuc93x/mach-nuc932evb.c 
b/arch/arm/mach-nuc93x/mach-nuc932evb.c
new file mode 100644
index 0000000..9f79266
--- /dev/null
+++ b/arch/arm/mach-nuc93x/mach-nuc932evb.c
@@ -0,0 +1,45 @@
+/*
+ * linux/arch/arm/mach-w90x900/mach-nuc910evb.c
+ *
+ * Based on mach-s3c2410/mach-smdk2410.c by Jonas Dietsche
+ *
+ * Copyright (C) 2008 Nuvoton technology corporation.
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
+    nuc932_map_io();
+    nuc932_init_clocks();
+    nuc932_init_uartclk();
+}
+
+static void __init nuc932evb_init(void)
+{
+    nuc932_board_init();
+}
+
+MACHINE_START(NUC932EVB, "NUC932EVB")
+    /* Maintainer: Wan ZongShun */
+    .phys_io    = NUC93X_PA_UART,
+    .io_pg_offst    = (((u32)NUC93X_VA_UART) >> 18) & 0xfffc,
+    .boot_params    = 0,
+    .map_io        = nuc932evb_map_io,
+    .init_irq    = nuc93x_init_irq,
+    .init_machine    = nuc932evb_init,
+    .timer        = &nuc93x_timer,
+MACHINE_END
diff --git a/arch/arm/mach-nuc93x/nuc932.c b/arch/arm/mach-nuc93x/nuc932.c
new file mode 100644
index 0000000..3966ead
--- /dev/null
+++ b/arch/arm/mach-nuc93x/nuc932.c
@@ -0,0 +1,65 @@
+/*
+ * linux/arch/arm/mach-nuc93x/nuc932.c
+ *
+ * Copyright (c) 2009 Nuvoton corporation.
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
+#include <linux/clk.h>
+#include <linux/err.h>
+
+#include <asm/mach/map.h>
+#include <mach/hardware.h>
+
+#include "cpu.h"
+#include "clock.h"
+
+/* define specific CPU platform device */
+
+static struct platform_device *nuc932_dev[] __initdata = {
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
+    nuc93x_map_io(nuc932evb_iodesc, ARRAY_SIZE(nuc932evb_iodesc));
+}
+
+/*Init NUC932 clock*/
+
+void __init nuc932_init_clocks(void)
+{
+    nuc93x_init_clocks();
+}
+
+/*enable NUC932 uart clock*/
+
+void __init nuc932_init_uartclk(void)
+{
+    struct clk *ck_uart = clk_get(NULL, "uart");
+    BUG_ON(IS_ERR(ck_uart));
+
+    clk_enable(ck_uart);
+}
+
+/*Init NUC932 board info*/
+
+void __init nuc932_board_init(void)
+{
+    nuc93x_board_init(nuc932_dev, ARRAY_SIZE(nuc932_dev));
+}
diff --git a/arch/arm/mach-nuc93x/nuc932.h b/arch/arm/mach-nuc93x/nuc932.h
new file mode 100644
index 0000000..9a66edd
--- /dev/null
+++ b/arch/arm/mach-nuc93x/nuc932.h
@@ -0,0 +1,29 @@
+/*
+ * arch/arm/mach-nuc93x/nuc932.h
+ *
+ * Copyright (c) 2008 Nuvoton corporation
+ *
+ * Header file for NUC93x CPU support
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
+extern void nuc93x_init_irq(void);
+extern struct sys_timer nuc93x_timer;
+
+/* extern file from nuc932.c */
+
+extern void nuc932_board_init(void);
+extern void nuc932_init_clocks(void);
+extern void nuc932_map_io(void);
+extern void nuc932_init_uartclk(void);
diff --git a/arch/arm/mach-nuc93x/time.c b/arch/arm/mach-nuc93x/time.c
new file mode 100644
index 0000000..2f90f9d
--- /dev/null
+++ b/arch/arm/mach-nuc93x/time.c
@@ -0,0 +1,100 @@
+/*
+ * linux/arch/arm/mach-nuc93x/time.c
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation.
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
+
+#include <asm/mach-types.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/time.h>
+
+#include <mach/system.h>
+#include <mach/map.h>
+#include <mach/regs-timer.h>
+
+#define RESETINT    0x01
+#define PERIOD        (0x01 << 27)
+#define ONESHOT        (0x00 << 27)
+#define COUNTEN        (0x01 << 30)
+#define INTEN        (0x01 << 29)
+
+#define TICKS_PER_SEC    100
+#define PRESCALE    0x63 /* Divider = prescale + 1 */
+
+unsigned int timer0_load;
+
+static unsigned long nuc93x_gettimeoffset(void)
+{
+    return 0;
+}
+
+/*IRQ handler for the timer*/
+
+static irqreturn_t nuc93x_timer_interrupt(int irq, void *dev_id)
+{
+    timer_tick();
+    __raw_writel(0x01, REG_TISR); /* clear TIF0 */
+    return IRQ_HANDLED;
+}
+
+static struct irqaction nuc93x_timer_irq = {
+    .name        = "nuc93x Timer Tick",
+    .flags        = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+    .handler    = nuc93x_timer_interrupt,
+};
+
+/*Set up timer reg.*/
+
+static void nuc93x_timer_setup(void)
+{
+    struct clk *ck_ext = clk_get(NULL, "ext");
+    struct clk *ck_timer = clk_get(NULL, "timer");
+    unsigned int rate, val = 0;
+
+    BUG_ON(IS_ERR(ck_ext) || IS_ERR(ck_timer));
+
+    clk_enable(ck_timer);
+    rate = clk_get_rate(ck_ext);
+    clk_put(ck_ext);
+    rate = rate / (PRESCALE + 0x01);
+
+     /* set a known state */
+    __raw_writel(0x00, REG_TCSR0);
+    __raw_writel(RESETINT, REG_TISR);
+
+    timer0_load = (rate / TICKS_PER_SEC);
+    __raw_writel(timer0_load, REG_TICR0);
+
+    val |= (PERIOD | COUNTEN | INTEN | PRESCALE);;
+    __raw_writel(val, REG_TCSR0);
+
+}
+
+static void __init nuc93x_timer_init(void)
+{
+    nuc93x_timer_setup();
+    setup_irq(IRQ_TIMER0, &nuc93x_timer_irq);
+}
+
+struct sys_timer nuc93x_timer = {
+    .init        = nuc93x_timer_init,
+    .offset        = nuc93x_gettimeoffset,
+    .resume        = nuc93x_timer_setup
+};
-- 
1.5.6.3

