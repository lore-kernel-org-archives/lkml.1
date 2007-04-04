Return-Path: <linux-kernel-owner+w=401wt.eu-S1422720AbXDDSWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422720AbXDDSWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934087AbXDDSNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:13:04 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38960 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934070AbXDDSMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:12:23 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kai Svahn <kai.svahn@nokia.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 62/90] ARM: OMAP: Merge board specific files from N800 tree
Date: Wed,  4 Apr 2007 14:05:41 -0400
Message-Id: <11757101352361-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101333782-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Svahn <kai.svahn@nokia.com>

This patch merges board specific files from N800 tree.
Nokia has published the files at:

http://repository.maemo.org/pool/maemo3.0/free/source/
kernel-source-rx-34_2.6.18.orig.tar.gz
kernel-source-rx-34_2.6.18-osso29.diff.gz

Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig            |    5 +
 arch/arm/mach-omap2/Makefile           |    4 +
 arch/arm/mach-omap2/board-n800-audio.c |  357 ++++++++++++++++++++++
 arch/arm/mach-omap2/board-n800-bt.c    |   42 +++
 arch/arm/mach-omap2/board-n800-dsp.c   |  158 ++++++++++
 arch/arm/mach-omap2/board-n800-flash.c |   61 ++++
 arch/arm/mach-omap2/board-n800-mmc.c   |  279 +++++++++++++++++
 arch/arm/mach-omap2/board-n800-pm.c    |   77 +++++
 arch/arm/mach-omap2/board-n800-usb.c   |  102 ++++++
 arch/arm/mach-omap2/board-n800.c       |  525 ++++++++++++++++++++++++++++++++
 include/asm-arm/arch-omap/board.h      |   24 ++-
 11 files changed, 1632 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 83608e4..845daa6 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -22,9 +22,14 @@ config MACH_OMAP_GENERIC
 	bool "Generic OMAP board"
 	depends on ARCH_OMAP2 && ARCH_OMAP24XX
 
+config MACH_NOKIA_N800
+	bool "Nokia N800"
+	depends on ARCH_OMAP24XX
+
 config MACH_OMAP2_TUSB6010
 	bool
 	depends on ARCH_OMAP2 && ARCH_OMAP2420
+	default y if MACH_NOKIA_N800
 
 config MACH_OMAP_H4
 	bool "OMAP 2420 H4 board"
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 626d9b8..5eee94f 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -20,6 +20,10 @@ obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
 obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o
 obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o
+obj-$(CONFIG_MACH_NOKIA_N800)		+= board-n800.o board-n800-flash.o \
+					   board-n800-mmc.o board-n800-bt.o \
+					   board-n800-audio.o board-n800-usb.o \
+					   board-n800-dsp.o board-n800-pm.o
 
 # TUSB 6010 chips
 obj-$(CONFIG_MACH_OMAP2_TUSB6010)	+= usb-tusb6010.o
diff --git a/arch/arm/mach-omap2/board-n800-audio.c b/arch/arm/mach-omap2/board-n800-audio.c
new file mode 100644
index 0000000..1608d3d
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800-audio.c
@@ -0,0 +1,357 @@
+/*
+ * linux/arch/arm/mach-omap/omap2/board-n800-audio.c
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Contact: Juha Yrj?l?
+ *          Jarkko Nikula <jarkko.nikula@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/spi/tsc2301.h>
+
+#include <asm/io.h>
+#include <asm/arch/eac.h>
+
+#include "../plat-omap/dsp/dsp_common.h"
+
+#if defined(CONFIG_SPI_TSC2301_AUDIO) && defined(CONFIG_SND_OMAP24XX_EAC)
+#define AUDIO_ENABLED
+
+static struct clk *sys_clkout2;
+static struct clk *func96m_clk;
+static struct device *eac_device;
+static struct device *tsc2301_device;
+
+static int enable_audio;
+static int audio_ok;
+static spinlock_t audio_lock;
+
+
+/*
+ * Leaving EAC pins multiplexed to EAC functionality results
+ * in about 2 mA extra current leaked. The workaround is to
+ * multiplex the EAC pins to protected mode (with pull-ups enabled)
+ * whenever audio is not being used.
+ */
+static int mux_disabled;
+static u32 saved_mux[2];
+
+static void n800_enable_eac_mux(void)
+{
+	if (!mux_disabled)
+		return;
+	__raw_writel(saved_mux[0], IO_ADDRESS(0x480000e8));
+	__raw_writel(saved_mux[1], IO_ADDRESS(0x48000124));
+	mux_disabled = 0;
+}
+
+static void n800_disable_eac_mux(void)
+{
+	u32 l;
+
+	if (mux_disabled) {
+		WARN_ON(mux_disabled);
+		return;
+	}
+	saved_mux[0] = __raw_readl(IO_ADDRESS(0x480000e8));
+	saved_mux[1] = __raw_readl(IO_ADDRESS(0x48000124));
+	l = saved_mux[0] & ~0xff;
+	l |= 0x1f;
+	__raw_writel(l, IO_ADDRESS(0x480000e8));
+	__raw_writel(0x1f1f1f1f, IO_ADDRESS(0x48000124));
+	mux_disabled = 1;
+}
+
+static int n800_eac_enable_ext_clocks(struct device *dev)
+{
+	BUG_ON(tsc2301_device == NULL);
+	n800_enable_eac_mux();
+	tsc2301_enable_mclk(tsc2301_device);
+
+	return 0;
+}
+
+static void n800_eac_disable_ext_clocks(struct device *dev)
+{
+	BUG_ON(tsc2301_device == NULL);
+	n800_disable_eac_mux();
+	tsc2301_disable_mclk(tsc2301_device);
+}
+
+static int n800_audio_set_power(void *pdata, int dac, int adc)
+{
+	BUG_ON(pdata != tsc2301_device);
+	tsc2301_mixer_set_power(tsc2301_device, dac, adc);
+
+	return 0;
+}
+
+static int n800_audio_register_controls(void *pdata, struct snd_card *card)
+{
+	BUG_ON(pdata != tsc2301_device);
+	return tsc2301_mixer_register_controls(tsc2301_device, card);
+}
+
+static struct eac_codec n800_eac_codec = {
+	.mclk_src = EAC_MCLK_EXT_2x12288000,
+	.codec_mode = EAC_CODEC_I2S,
+	.codec_conf.i2s.polarity_changed_mode = 0,
+	.codec_conf.i2s.sync_delay_enable = 0,
+	.default_rate = 48000,
+	.set_power = n800_audio_set_power,
+	.register_controls = n800_audio_register_controls,
+	.short_name = "TSC2301",
+};
+
+static int n800_register_codec(void)
+{
+	int r, do_enable = 0;
+	unsigned long flags;
+
+	n800_eac_codec.private_data = tsc2301_device;
+	r = eac_register_codec(eac_device, &n800_eac_codec);
+	if (r < 0)
+		return r;
+	spin_lock_irqsave(&audio_lock, flags);
+	audio_ok = 1;
+	if (enable_audio)
+		do_enable = 1;
+	spin_unlock_irqrestore(&audio_lock, flags);
+	if (do_enable)
+		eac_set_mode(eac_device, 1, 1);
+	return 0;
+}
+
+static void n800_unregister_codec(void)
+{
+	audio_ok = 0;
+	eac_unregister_codec(eac_device);
+	eac_set_mode(eac_device, 0, 0);
+}
+
+static int n800_eac_init(struct device *dev)
+{
+	int r;
+
+	BUG_ON(eac_device != NULL);
+	eac_device = dev;
+	if (tsc2301_device != NULL) {
+		r = n800_register_codec();
+		if (r < 0)
+			return r;
+	}
+
+	return 0;
+}
+
+static void n800_eac_cleanup(struct device *dev)
+{
+	eac_device = NULL;
+	if (tsc2301_device != NULL)
+		n800_unregister_codec();
+}
+
+static int n800_codec_get_clocks(struct device *dev)
+{
+	sys_clkout2 = clk_get(dev, "sys_clkout2");
+	if (IS_ERR(sys_clkout2)) {
+		printk(KERN_ERR "Could not get sys_clkout2\n");
+		return -ENODEV;
+	}
+	/* configure 12 MHz output on SYS_CLKOUT2. Therefore we must use
+	 * 96 MHz as its parent in order to get 12 MHz */
+	func96m_clk = clk_get(dev, "func_96m_ck");
+	if (IS_ERR(func96m_clk)) {
+		printk(KERN_ERR "could not get func 96M clock\n");
+		clk_put(sys_clkout2);
+		return -ENODEV;
+	}
+
+	clk_set_parent(sys_clkout2, func96m_clk);
+	clk_set_rate(sys_clkout2, 12000000);
+
+	return 0;
+}
+
+static void n800_codec_put_clocks(struct device *dev)
+{
+	clk_put(func96m_clk);
+	clk_put(sys_clkout2);
+}
+
+static int n800_codec_enable_clock(struct device *dev)
+{
+	int err;
+
+	err = clk_enable(sys_clkout2);
+	if (err)
+		return err;
+	/* TODO: 'educated' guess for audio codec's PLL startup delay */
+	mdelay(1);
+
+	return 0;
+}
+
+static void n800_codec_disable_clock(struct device *dev)
+{
+	clk_disable(sys_clkout2);
+}
+
+static int n800_codec_init(struct device *dev)
+{
+	int r;
+
+	BUG_ON(tsc2301_device != NULL);
+	tsc2301_device = dev;
+	if ((r = n800_codec_get_clocks(dev)) < 0)
+		return r;
+	if (eac_device != NULL) {
+		r = n800_register_codec();
+		if (r < 0) {
+			n800_codec_put_clocks(dev);
+			return r;
+		}
+	}
+	return 0;
+}
+
+static void n800_codec_cleanup(struct device *dev)
+{
+	tsc2301_device = NULL;
+	if (eac_device != NULL)
+		n800_unregister_codec();
+	n800_codec_put_clocks(dev);
+}
+
+static struct eac_platform_data n800_eac_data = {
+	.init = n800_eac_init,
+	.cleanup = n800_eac_cleanup,
+	.enable_ext_clocks = n800_eac_enable_ext_clocks,
+	.disable_ext_clocks = n800_eac_disable_ext_clocks,
+};
+
+static const struct tsc2301_mixer_gpio n800_mixer_gpios[] = {
+	{
+		.name			= "Headset Amplifier",
+		.gpio			= 1,
+		.deactivate_on_pd	= 1,
+	}, {
+		.name			= "Speaker Amplifier",
+		.gpio			= 2,
+		.def_enable		= 1,
+		.deactivate_on_pd	= 1,
+	}, {
+		.name			= "Headset Mic Select",
+		.gpio			= 3,
+	}
+};
+
+static struct platform_device retu_headset_device = {
+	.name		= "retu-headset",
+	.id		= -1,
+	.dev		= {
+		.release	= NULL,
+	},
+};
+
+void __init n800_audio_init(struct tsc2301_platform_data *tc)
+{
+	spin_lock_init(&audio_lock);
+
+	if (platform_device_register(&retu_headset_device) < 0)
+		return;
+	omap_init_eac(&n800_eac_data);
+
+	tc->pll_pdc = 7;
+	tc->pll_a = 7;
+	tc->pll_n = 9;
+	tc->pll_output = 1;
+	tc->mclk_ratio = TSC2301_MCLK_256xFS;
+	tc->i2s_sample_rate = TSC2301_I2S_SR_48000;
+	tc->i2s_format = TSC2301_I2S_FORMAT0;
+	tc->power_down_blocks = TSC2301_REG_PD_MISC_MOPD;
+	tc->mixer_gpios = n800_mixer_gpios;
+	tc->n_mixer_gpios = ARRAY_SIZE(n800_mixer_gpios);
+	tc->codec_init = n800_codec_init;
+	tc->codec_cleanup = n800_codec_cleanup;
+	tc->enable_clock = n800_codec_enable_clock;
+	tc->disable_clock = n800_codec_disable_clock;
+}
+
+#else
+
+void __init n800_audio_init(void)
+{
+}
+
+#endif
+
+#ifdef CONFIG_OMAP_DSP
+
+int n800_audio_enable(struct dsp_kfunc_device *kdev, int stage)
+{
+#ifdef AUDIO_ENABLED
+	unsigned long flags;
+	int do_enable = 0;
+
+	spin_lock_irqsave(&audio_lock, flags);
+
+	pr_debug("DSP power up request (audio codec %sinitialized)\n",
+		 audio_ok ? "" : "not ");
+
+	if (enable_audio)
+		goto out;
+	enable_audio = 1;
+	if (audio_ok)
+		do_enable = 1;
+out:
+	spin_unlock_irqrestore(&audio_lock, flags);
+	if (do_enable)
+		eac_set_mode(eac_device, 1, 1);
+#endif
+	return 0;
+}
+
+int n800_audio_disable(struct dsp_kfunc_device *kdev, int stage)
+{
+#ifdef AUDIO_ENABLED
+	unsigned long flags;
+	int do_disable = 0;
+
+	spin_lock_irqsave(&audio_lock, flags);
+
+	pr_debug("DSP power down request (audio codec %sinitialized)\n",
+		audio_ok ? "" : "not ");
+
+	if (!enable_audio)
+		goto out;
+	enable_audio = 0;
+	if (audio_ok)
+		do_disable = 1;
+out:
+	spin_unlock_irqrestore(&audio_lock, flags);
+	if (do_disable)
+		eac_set_mode(eac_device, 0, 0);
+#endif
+	return 0;
+}
+
+#endif /* CONFIG_OMAP_DSP */
diff --git a/arch/arm/mach-omap2/board-n800-bt.c b/arch/arm/mach-omap2/board-n800-bt.c
new file mode 100644
index 0000000..4ea19cc
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800-bt.c
@@ -0,0 +1,42 @@
+/*
+ * Nokia N800 platform-specific data for Bluetooth
+ *
+ * Copyright (C) 2005, 2006 Nokia Corporation
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <asm/arch/board.h>
+
+static struct platform_device n800_bt_device = {
+	.name           = "hci_h4p",
+	.id             = -1,
+	.num_resources  = 0,
+};
+
+void __init n800_bt_init(void)
+{
+	const struct omap_bluetooth_config *bt_config;
+
+	bt_config = (void *) omap_get_config(OMAP_TAG_NOKIA_BT,
+					     struct omap_bluetooth_config);
+	n800_bt_device.dev.platform_data = (void *) bt_config;
+	if (platform_device_register(&n800_bt_device) < 0)
+		BUG();
+}
+
diff --git a/arch/arm/mach-omap2/board-n800-dsp.c b/arch/arm/mach-omap2/board-n800-dsp.c
new file mode 100644
index 0000000..cb01363
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800-dsp.c
@@ -0,0 +1,158 @@
+/*
+ * linux/arch/arm/mach-omap2/board-n800-dsp.c
+ *
+ * Copyright (C) 2006 Nokia Corporation.
+ *
+ * Contact: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+
+#include <asm/io.h>
+#include <asm/arch/clock.h>
+
+#include "../plat-omap/dsp/dsp_common.h"
+
+extern int n800_audio_enable(struct dsp_kfunc_device *kdev, int stage);
+extern int n800_audio_disable(struct dsp_kfunc_device *kdev, int stage);
+
+#if	defined(CONFIG_OMAP_DSP)
+
+/*
+ * dsp peripheral device: AUDIO
+ */
+static struct dsp_kfunc_device n800_audio_device = {
+	.name	 = "audio",
+	.type	 = DSP_KFUNC_DEV_TYPE_AUDIO,
+	.enable	 = n800_audio_enable,
+	.disable = n800_audio_disable,
+};
+
+/*
+ * dsp peripheral device: TIMER
+ */
+static int dsp_timer_probe(struct dsp_kfunc_device *kdev)
+{
+	char clockname[20];
+
+	strcpy(clockname, kdev->name);
+	strcat(clockname, "_fck");
+
+	kdev->fck = clk_get(NULL, clockname);
+	if (IS_ERR(kdev->fck)) {
+		printk(KERN_ERR "couldn't acquire %s\n", clockname);
+		return PTR_ERR(kdev->fck);
+	}
+	pr_debug("%s probed successfully\n", clockname);
+
+	strcpy(clockname, kdev->name);
+	strcat(clockname, "_ick");
+	kdev->ick = clk_get(NULL, clockname);
+	if (IS_ERR(kdev->ick)) {
+		printk(KERN_ERR "couldn't acquire %s\n", clockname);
+		goto fail;
+	}
+	pr_debug("%s probed successfully\n", clockname);
+
+	return 0;
+ fail:
+	clk_put(kdev->fck);
+
+	return PTR_ERR(kdev->ick);
+}
+
+static int dsp_timer_remove(struct dsp_kfunc_device *kdev)
+{
+	clk_put(kdev->ick);
+	clk_put(kdev->fck);
+	pr_debug("%s removed successfully\n", kdev->name);
+	return 0;
+}
+
+static int dsp_timer_enable(struct dsp_kfunc_device *kdev, int stage)
+{
+	pr_debug("%s enabled(%d)\n", kdev->name, stage);
+
+	mutex_lock(&kdev->lock);
+
+	if (kdev->enabled)
+		goto out;
+	kdev->enabled = 1;
+
+	clk_enable(kdev->fck);
+	clk_enable(kdev->ick);
+ out:
+	mutex_unlock(&kdev->lock);
+
+	return 0;
+}
+
+static int dsp_timer_disable(struct dsp_kfunc_device *kdev, int stage)
+{
+	pr_debug("%s disabled(%d)\n", kdev->name, stage);
+
+	mutex_lock(&kdev->lock);
+
+	if (kdev->enabled == 0)
+		goto out;
+	kdev->enabled = 0;
+
+	clk_disable(kdev->ick);
+	clk_disable(kdev->fck);
+ out:
+	mutex_unlock(&kdev->lock);
+
+	return 0;
+}
+
+static struct dsp_kfunc_device n800_timer_device = {
+	.name	 = "gpt5",
+	.type	 = DSP_KFUNC_DEV_TYPE_COMMON,
+	.probe	 = dsp_timer_probe,
+	.remove	 = dsp_timer_remove,
+	.enable	 = dsp_timer_enable,
+	.disable = dsp_timer_disable,
+};
+
+static struct dsp_kfunc_device *n800_kfunc_dev[] = {
+	&n800_audio_device,
+	&n800_timer_device,
+};
+
+void __init n800_dsp_init(void)
+{
+	int i, ret;
+	struct dsp_kfunc_device **p = n800_kfunc_dev;
+
+	for (i = 0; i < ARRAY_SIZE(n800_kfunc_dev); i++) {
+		ret = dsp_kfunc_device_register(p[i]);
+		if (ret) {
+			printk(KERN_ERR
+			       "KFUNC device registration failed: %s\n",
+			       p[i]->name);
+		}
+	}
+}
+
+#else
+void __init n800_dsp_init(void) { }
+#endif	/* CONFIG_OMAP_DSP */
diff --git a/arch/arm/mach-omap2/board-n800-flash.c b/arch/arm/mach-omap2/board-n800-flash.c
new file mode 100644
index 0000000..3a4c52a
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800-flash.c
@@ -0,0 +1,61 @@
+/*
+ * linux/arch/arm/mach-omap/omap2/board-n800-flash.c
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Author: Juha Yrjola
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <asm/mach/flash.h>
+#include <asm/arch/onenand.h>
+#include <asm/arch/board.h>
+
+static struct mtd_partition n800_partitions[8];
+
+static struct omap_onenand_platform_data n800_onenand_data = {
+	.cs = 0,
+	.gpio_irq = 26,
+	.parts = n800_partitions,
+	.nr_parts = 0 /* filled later */
+};
+
+static struct platform_device n800_onenand_device = {
+	.name		= "omap2-onenand",
+	.id		= -1,
+	.dev = {
+		.platform_data = &n800_onenand_data,
+	},
+};
+
+
+void __init n800_flash_init(void)
+{
+	const struct omap_partition_config *part;
+	int i = 0;
+
+	while ((part = omap_get_nr_config(OMAP_TAG_PARTITION,
+					  struct omap_partition_config, i)) != NULL) {
+		struct mtd_partition *mpart;
+
+		mpart = n800_partitions + i;
+		mpart->name = (char *) part->name;
+		mpart->size = part->size;
+		mpart->offset = part->offset;
+		mpart->mask_flags = part->mask_flags;
+		i++;
+		if (i == ARRAY_SIZE(n800_partitions)) {
+			printk(KERN_ERR "Too many partitions supplied\n");
+			return;
+		}
+	}
+	n800_onenand_data.nr_parts = i;
+	if (platform_device_register(&n800_onenand_device) < 0) {
+		printk(KERN_ERR "Unable to register OneNAND device\n");
+		return;
+	}
+}
diff --git a/arch/arm/mach-omap2/board-n800-mmc.c b/arch/arm/mach-omap2/board-n800-mmc.c
new file mode 100644
index 0000000..b20f1ad
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800-mmc.c
@@ -0,0 +1,279 @@
+/*
+ * linux/arch/arm/mach-omap2/board-n800-mmc.c
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Author: Juha Yrj?l?
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/arch/mmc.h>
+#include <asm/arch/menelaus.h>
+#include <asm/arch/gpio.h>
+
+#ifdef CONFIG_MMC_OMAP
+
+static const int slot_switch_gpio = 96;
+static const int slot1_wp_gpio = 23;
+static const int slot2_wp_gpio = 8;
+static int slot1_cover_closed;
+static int slot2_cover_closed;
+static struct device *mmc_device;
+
+/*
+ * VMMC --> slot 1
+ * VDCDC3_APE, VMCS2_APE --> slot 2
+ * GPIO96 --> Menelaus GPIO2
+ */
+
+static int n800_mmc_switch_slot(struct device *dev, int slot)
+{
+#ifdef CONFIG_MMC_DEBUG
+	printk("Choose slot %d\n", slot + 1);
+#endif
+	if (slot == 0)
+		omap_set_gpio_dataout(slot_switch_gpio, 0);
+	else
+		omap_set_gpio_dataout(slot_switch_gpio, 1);
+	return 0;
+}
+
+static int n800_mmc_set_power(struct device *dev, int slot, int power_on, int vdd)
+{
+	int mV;
+
+#ifdef CONFIG_MMC_DEBUG
+	printk("Set slot %d power: %s (vdd %d)\n", slot + 1,
+	       power_on ? "on" : "off", vdd);
+#endif
+	if (slot == 0) {
+		if (!power_on)
+			return menelaus_set_vmmc(0);
+		switch (1 << vdd) {
+		case MMC_VDD_33_34:
+		case MMC_VDD_32_33:
+		case MMC_VDD_31_32:
+			mV = 3100;
+			break;
+		case MMC_VDD_30_31:
+			mV = 3000;
+			break;
+		case MMC_VDD_28_29:
+			mV = 2800;
+			break;
+		case MMC_VDD_18_19:
+			mV = 1850;
+			break;
+		default:
+			BUG();
+		}
+		return menelaus_set_vmmc(mV);
+	} else {
+		if (!power_on)
+			return menelaus_set_vdcdc(3, 0);
+		switch (1 << vdd) {
+		case MMC_VDD_33_34:
+		case MMC_VDD_32_33:
+			mV = 3300;
+			break;
+		case MMC_VDD_30_31:
+		case MMC_VDD_29_30:
+			mV = 3000;
+			break;
+		case MMC_VDD_28_29:
+		case MMC_VDD_27_28:
+			mV = 2800;
+			break;
+		case MMC_VDD_24_25:
+		case MMC_VDD_23_24:
+			mV = 2400;
+			break;
+		case MMC_VDD_22_23:
+		case MMC_VDD_21_22:
+			mV = 2200;
+			break;
+		case MMC_VDD_20_21:
+		case MMC_VDD_19_20:
+			mV = 2000;
+			break;
+		case MMC_VDD_18_19:
+		case MMC_VDD_17_18:
+			mV = 1800;
+			break;
+		case MMC_VDD_150_155:
+		case MMC_VDD_145_150:
+			mV = 1500;
+			break;
+		default:
+			BUG();
+		}
+		return menelaus_set_vdcdc(3, mV);
+	}
+	return 0;
+}
+
+static int n800_mmc_set_bus_mode(struct device *dev, int slot, int bus_mode)
+{
+	int r;
+
+#ifdef CONFIG_MMC_DEBUG
+	printk("Set slot %d bus mode %s\n", slot + 1,
+	       bus_mode == MMC_BUSMODE_OPENDRAIN ? "open-drain" : "push-pull");
+#endif
+	BUG_ON(slot != 0 && slot != 1);
+	slot++;
+	switch (bus_mode) {
+	case MMC_BUSMODE_OPENDRAIN:
+		r = menelaus_set_mmc_opendrain(slot, 1);
+		break;
+	case MMC_BUSMODE_PUSHPULL:
+		r = menelaus_set_mmc_opendrain(slot, 0);
+		break;
+	default:
+		BUG();
+	}
+	if (r != 0 && printk_ratelimit())
+		printk(KERN_ERR "MMC: unable to set bus mode for slot %d\n", slot);
+	return r;
+}
+
+#if 0
+static int n800_mmc_get_ro(struct device *dev, int slot)
+{
+	int ro;
+
+	slot++;
+	if (slot == 1)
+		ro = omap_get_gpio_datain(slot1_wp_gpio);
+	else
+		ro = omap_get_gpio_datain(slot2_wp_gpio);
+#ifdef CONFIG_MMC_DEBUG
+	printk("Get RO slot %d: %s\n", slot, ro ? "read-only" : "read-write");
+#endif
+	return ro;
+}
+#endif
+
+static int n800_mmc_get_cover_state(struct device *dev, int slot)
+{
+	slot++;
+	BUG_ON(slot != 1 && slot != 2);
+	if (slot == 1)
+		return slot1_cover_closed;
+	else
+		return slot2_cover_closed;
+}
+
+static void n800_mmc_callback(void *data, u8 card_mask)
+{
+	if (card_mask & (1 << 1))
+		slot2_cover_closed = 0;
+	else
+		slot2_cover_closed = 1;
+        omap_mmc_notify_cover_event(mmc_device, 1, slot2_cover_closed);
+}
+
+void n800_mmc_slot1_cover_handler(void *arg, int state)
+{
+	if (mmc_device == NULL)
+		return;
+
+	slot1_cover_closed = state;
+	omap_mmc_notify_cover_event(mmc_device, 0, state);
+}
+
+static int n800_mmc_late_init(struct device *dev)
+{
+	int r;
+
+	mmc_device = dev;
+
+	r = menelaus_set_slot_sel(1);
+	if (r < 0)
+		return r;
+
+	r = menelaus_set_mmc_slot(1, 1, 0, 1);
+	if (r < 0)
+		return r;
+	r = menelaus_set_mmc_slot(2, 1, 0, 1);
+	if (r < 0)
+		return r;
+
+	r = menelaus_get_slot_pin_states();
+	if (r < 0)
+		return r;
+
+	if (r & (1 << 1))
+		slot2_cover_closed = 1;
+	else
+		slot2_cover_closed = 0;
+
+	r = menelaus_register_mmc_callback(n800_mmc_callback, NULL);
+
+	return r;
+}
+
+static void n800_mmc_cleanup(struct device *dev)
+{
+	menelaus_unregister_mmc_callback();
+}
+
+static struct omap_mmc_platform_data n800_mmc_data = {
+	.enabled		= 1,
+	.nr_slots		= 2,
+	.wire4			= 1,
+	.switch_slot		= n800_mmc_switch_slot,
+	.init			= n800_mmc_late_init,
+	.cleanup		= n800_mmc_cleanup,
+	.slots[0] = {
+		.set_power	= n800_mmc_set_power,
+		.set_bus_mode	= n800_mmc_set_bus_mode,
+		.get_ro		= NULL,
+		.get_cover_state= n800_mmc_get_cover_state,
+		.ocr_mask	= MMC_VDD_18_19 | MMC_VDD_28_29 | MMC_VDD_30_31 |
+				  MMC_VDD_32_33 | MMC_VDD_33_34,
+		.name		= "internal",
+	},
+	.slots[1] = {
+		.set_power	= n800_mmc_set_power,
+		.set_bus_mode	= n800_mmc_set_bus_mode,
+		.get_ro		= NULL,
+		.get_cover_state= n800_mmc_get_cover_state,
+		.ocr_mask	= MMC_VDD_150_155 | MMC_VDD_145_150 | MMC_VDD_17_18 |
+				  MMC_VDD_18_19 | MMC_VDD_19_20 | MMC_VDD_20_21 |
+				  MMC_VDD_21_22 | MMC_VDD_22_23 | MMC_VDD_23_24 |
+				  MMC_VDD_24_25 | MMC_VDD_27_28 | MMC_VDD_28_29 |
+				  MMC_VDD_29_30 | MMC_VDD_30_31 | MMC_VDD_32_33 |
+				  MMC_VDD_33_34,
+		.name		= "external",
+	},
+};
+
+void __init n800_mmc_init(void)
+{
+	omap_set_mmc_info(1, &n800_mmc_data);
+	if (omap_request_gpio(slot_switch_gpio) < 0)
+		BUG();
+	omap_set_gpio_dataout(slot_switch_gpio, 0);
+	omap_set_gpio_direction(slot_switch_gpio, 0);
+	if (omap_request_gpio(slot1_wp_gpio) < 0)
+		BUG();
+	if (omap_request_gpio(slot2_wp_gpio) < 0)
+		BUG();
+	omap_set_gpio_direction(slot1_wp_gpio, 1);
+	omap_set_gpio_direction(slot2_wp_gpio, 1);
+}
+
+#else
+
+void __init n800_mmc_init(void)
+{
+}
+
+void n800_mmc_slot1_cover_handler(void *arg, int state)
+{
+}
+
+#endif
diff --git a/arch/arm/mach-omap2/board-n800-pm.c b/arch/arm/mach-omap2/board-n800-pm.c
new file mode 100644
index 0000000..fb2873e
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800-pm.c
@@ -0,0 +1,77 @@
+/*
+ * Nokia N800 PM code
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Author: Amit Kucheria <amit.kucheria@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/arch/menelaus.h>
+
+#ifdef CONFIG_MENELAUS
+
+static int n800_auto_sleep_regulators(void)
+{
+	u32 val;
+	int ret;
+
+	val = EN_VPLL_SLEEP | EN_VMMC_SLEEP    \
+		| EN_VAUX_SLEEP | EN_VIO_SLEEP \
+		| EN_VMEM_SLEEP | EN_DC3_SLEEP \
+		| EN_VC_SLEEP | EN_DC2_SLEEP;
+
+	ret = menelaus_set_regulator_sleep(1, val);
+	if (ret < 0) {
+		printk(KERN_ERR "Could not set regulators to sleep on menelaus: %u\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int n800_auto_voltage_scale(void)
+{
+	int ret;
+
+	ret = menelaus_set_vcore_hw(1400, 1050);
+	if (ret < 0) {
+		printk(KERN_ERR "Could not set VCORE voltage on menelaus: %u\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int n800_menelaus_init(struct device *dev)
+{
+	int ret;
+
+	ret = n800_auto_voltage_scale();
+	if (ret < 0)
+		return ret;
+	ret = n800_auto_sleep_regulators();
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static struct menelaus_platform_data n800_menelaus_platform_data = {
+	.late_init = n800_menelaus_init,
+};
+
+void __init n800_pm_init(void)
+{
+	menelaus_set_platform_data(&n800_menelaus_platform_data);
+}
+
+#else
+
+void __init n800_pm_init(void)
+{
+}
+
+#endif
+
diff --git a/arch/arm/mach-omap2/board-n800-usb.c b/arch/arm/mach-omap2/board-n800-usb.c
new file mode 100644
index 0000000..75243ac
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800-usb.c
@@ -0,0 +1,102 @@
+/*
+ * linux/arch/arm/mach-omap/omap2/board-n800-usb.c
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Author: Juha Yrj?l?
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/usb/musb.h>
+#include <asm/arch/gpmc.h>
+#include <asm/arch/gpio.h>
+
+#define TUSB_ASYNC_CS		1
+#define TUSB_SYNC_CS		4
+#define GPIO_TUSB_INT		58
+#define GPIO_TUSB_ENABLE	0
+
+static int tusb_set_power(int state);
+
+#if	defined(CONFIG_USB_MUSB_OTG)
+#	define BOARD_MODE	MUSB_OTG
+#elif	defined(CONFIG_USB_MUSB_PERIPHERAL)
+#	define BOARD_MODE	MUSB_PERIPHERAL
+#else	/* defined(CONFIG_USB_MUSB_HOST) */
+#	define BOARD_MODE	MUSB_HOST
+#endif
+
+static struct musb_hdrc_platform_data tusb_data = {
+	.mode		= BOARD_MODE,
+	.multipoint	= 1,
+	.set_power	= tusb_set_power,
+	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
+};
+
+/*
+ * Enable or disable power to TUSB6010. When enabling, turn on 3.3 V and
+ * 1.5 V voltage regulators of PM companion chip. Companion chip will then
+ * provide then PGOOD signal to TUSB6010 which will release it from reset.
+ */
+static int tusb_set_power(int state)
+{
+	int i, retval = 0;
+
+	if (state) {
+		omap_set_gpio_dataout(GPIO_TUSB_ENABLE, 1);
+		msleep(1);
+
+		/* Wait until TUSB6010 pulls INT pin down */
+		i = 100;
+		while (i && omap_get_gpio_datain(GPIO_TUSB_INT)) {
+			msleep(1);
+			i--;
+		}
+
+		if (!i) {
+			printk(KERN_ERR "tusb: powerup failed\n");
+			retval = -ENODEV;
+		}
+	} else {
+		omap_set_gpio_dataout(GPIO_TUSB_ENABLE, 0);
+		msleep(10);
+	}
+
+	return retval;
+}
+
+void __init n800_usb_init(void)
+{
+	int ret = 0;
+	static char	announce[] __initdata = KERN_INFO "TUSB 6010\n";
+
+	/* PM companion chip power control pin */
+	ret = omap_request_gpio(GPIO_TUSB_ENABLE);
+	if (ret != 0) {
+		printk(KERN_ERR "Could not get TUSB power GPIO%i\n",
+		       GPIO_TUSB_ENABLE);
+		return;
+	}
+	omap_set_gpio_direction(GPIO_TUSB_ENABLE, 0);
+
+	tusb_set_power(0);
+
+	ret = tusb6010_setup_interface(&tusb_data, TUSB6010_REFCLK_19, 2,
+					TUSB_ASYNC_CS, TUSB_SYNC_CS,
+					GPIO_TUSB_INT, 0x3f);
+	if (ret != 0)
+		goto err;
+
+	printk(announce);
+
+	return;
+
+err:
+	omap_free_gpio(GPIO_TUSB_ENABLE);
+}
diff --git a/arch/arm/mach-omap2/board-n800.c b/arch/arm/mach-omap2/board-n800.c
new file mode 100644
index 0000000..2188294
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n800.c
@@ -0,0 +1,525 @@
+/*
+ * linux/arch/arm/mach-omap/omap2/board-n800.c
+ *
+ * Copyright (C) 2005 Nokia Corporation
+ * Author: Juha Yrj?l? <juha.yrjola@nokia.com>
+ *
+ * Modified from mach-omap2/board-generic.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/tsc2301.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <asm/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/arch/gpio.h>
+#include <asm/arch/usb.h>
+#include <asm/arch/board.h>
+#include <asm/arch/common.h>
+#include <asm/arch/mcspi.h>
+#include <asm/arch/menelaus.h>
+#include <asm/arch/lcd_mipid.h>
+#include <asm/arch/clock.h>
+#include <asm/arch/gpio-switch.h>
+#include <asm/arch/omapfb.h>
+#include <asm/arch/blizzard.h>
+
+#include <../drivers/cbus/tahvo.h>
+
+#define N800_BLIZZARD_POWERDOWN_GPIO 15
+#define N800_STI_GPIO		62
+#define N800_CAM_SENSOR_RESET_GPIO	53
+#define N800_KEYB_IRQ_GPIO		109
+
+static void __init nokia_n800_init_irq(void)
+{
+	omap2_init_common_hw();
+	omap_init_irq();
+	omap_gpio_init();
+
+#ifdef CONFIG_OMAP_STI
+	if (omap_request_gpio(N800_STI_GPIO) < 0) {
+		printk(KERN_ERR "Failed to request GPIO %d for STI\n",
+		       N800_STI_GPIO);
+		return;
+	}
+
+	omap_set_gpio_direction(N800_STI_GPIO, 0);
+	omap_set_gpio_dataout(N800_STI_GPIO, 0);
+#endif
+}
+
+#if defined(CONFIG_MENELAUS) && defined(CONFIG_SENSORS_TMP105)
+
+static int n800_tmp105_set_power(int enable)
+{
+	return menelaus_set_vaux(enable ? 2800 : 0);
+}
+
+#else
+
+#define n800_tmp105_set_power NULL
+
+#endif
+
+static struct omap_uart_config n800_uart_config __initdata = {
+	.enabled_uarts = (1 << 0) | (1 << 2),
+};
+
+#include "../../../drivers/cbus/retu.h"
+
+static struct omap_fbmem_config n800_fbmem0_config __initdata = {
+	.size = 752 * 1024,
+};
+
+static struct omap_fbmem_config n800_fbmem1_config __initdata = {
+	.size = 752 * 1024,
+};
+
+static struct omap_fbmem_config n800_fbmem2_config __initdata = {
+	.size = 752 * 1024,
+};
+
+static struct omap_tmp105_config n800_tmp105_config __initdata = {
+	.tmp105_irq_pin = 125,
+	.set_power = n800_tmp105_set_power,
+};
+
+static void mipid_shutdown(struct mipid_platform_data *pdata)
+{
+	if (pdata->nreset_gpio != -1) {
+		pr_info("shutdown LCD\n");
+		omap_set_gpio_dataout(pdata->nreset_gpio, 0);
+		msleep(120);
+	}
+}
+
+static struct mipid_platform_data n800_mipid_platform_data = {
+	.shutdown = mipid_shutdown,
+};
+
+static void __init mipid_dev_init(void)
+{
+	const struct omap_lcd_config *conf;
+
+	conf = omap_get_config(OMAP_TAG_LCD, struct omap_lcd_config);
+	if (conf != NULL) {
+		n800_mipid_platform_data.nreset_gpio = conf->nreset_gpio;
+		n800_mipid_platform_data.data_lines = conf->data_lines;
+	}
+}
+
+static struct {
+	struct clk *sys_ck;
+} blizzard;
+
+static int blizzard_get_clocks(void)
+{
+	blizzard.sys_ck = clk_get(0, "osc_ck");
+	if (IS_ERR(blizzard.sys_ck)) {
+		printk(KERN_ERR "can't get Blizzard clock\n");
+		return PTR_ERR(blizzard.sys_ck);
+	}
+	return 0;
+}
+
+static unsigned long blizzard_get_clock_rate(struct device *dev)
+{
+	return clk_get_rate(blizzard.sys_ck);
+}
+
+static void blizzard_enable_clocks(int enable)
+{
+	if (enable)
+		clk_enable(blizzard.sys_ck);
+	else
+		clk_disable(blizzard.sys_ck);
+}
+
+static void blizzard_power_up(struct device *dev)
+{
+	/* Vcore to 1.475V */
+	tahvo_set_clear_reg_bits(0x07, 0, 0xf);
+	msleep(10);
+
+	blizzard_enable_clocks(1);
+	omap_set_gpio_dataout(N800_BLIZZARD_POWERDOWN_GPIO, 1);
+}
+
+static void blizzard_power_down(struct device *dev)
+{
+	omap_set_gpio_dataout(N800_BLIZZARD_POWERDOWN_GPIO, 0);
+	blizzard_enable_clocks(0);
+
+	/* Vcore to 1.005V */
+	tahvo_set_clear_reg_bits(0x07, 0xf, 0);
+}
+
+static struct blizzard_platform_data n800_blizzard_data = {
+	.power_up	= blizzard_power_up,
+	.power_down	= blizzard_power_down,
+	.get_clock_rate	= blizzard_get_clock_rate,
+	.te_connected	= 1,
+};
+
+static void __init blizzard_dev_init(void)
+{
+	int r;
+
+	r = omap_request_gpio(N800_BLIZZARD_POWERDOWN_GPIO);
+	if (r < 0)
+		return;
+	omap_set_gpio_direction(N800_BLIZZARD_POWERDOWN_GPIO, 0);
+	omap_set_gpio_dataout(N800_BLIZZARD_POWERDOWN_GPIO, 1);
+
+	blizzard_get_clocks();
+	omapfb_set_ctrl_platform_data(&n800_blizzard_data);
+}
+
+#if defined(CONFIG_CBUS_RETU) && defined(CONFIG_VIDEO_CAMERA_SENSOR_TCM825X) && \
+	defined(CONFIG_MENELAUS)
+#define SUPPORT_SENSOR
+#endif
+
+#ifdef SUPPORT_SENSOR
+
+static int sensor_okay;
+
+/*
+ * VSIM1	--> CAM_IOVDD	--> IOVDD (1.8 V)
+ */
+static int tcm825x_sensor_power_on(void *data)
+{
+	int ret;
+
+	if (!sensor_okay)
+		return -ENODEV;
+
+	/* Set VMEM to 1.5V and VIO to 2.5V */
+	ret = menelaus_set_vmem(1500);
+	if (ret < 0) {
+		/* Try once more, it seems the sensor power up causes
+		 * some problems on the I2C bus. */
+		ret = menelaus_set_vmem(1500);
+		if (ret < 0)
+			return ret;
+	}
+	msleep(1);
+
+	ret = menelaus_set_vio(2500);
+	if (ret < 0)
+		return ret;
+
+	/* Set VSim1 on */
+	retu_write_reg(RETU_REG_CTRL_SET, 0x0080);
+	msleep(100);
+
+	omap_set_gpio_dataout(N800_CAM_SENSOR_RESET_GPIO, 1);
+	msleep(1);
+
+	return 0;
+}
+
+static int tcm825x_sensor_power_off(void * data)
+{
+	int ret;
+
+	omap_set_gpio_dataout(N800_CAM_SENSOR_RESET_GPIO, 0);
+	msleep(1);
+
+	/* Set VSim1 off */
+	retu_write_reg(RETU_REG_CTRL_CLR, 0x0080);
+	msleep(1);
+
+	/* Set VIO_MODE to off */
+	ret = menelaus_set_vio(0);
+	if (ret < 0)
+		return ret;
+	msleep(1);
+
+	/* Set VMEM_MODE to off */
+	ret = menelaus_set_vmem(0);
+	if (ret < 0)
+		return ret;
+	msleep(1);
+
+	return 0;
+}
+
+static struct omap_camera_sensor_config n800_sensor_config = {
+	.power_on   = tcm825x_sensor_power_on,
+	.power_off  = tcm825x_sensor_power_off,
+};
+
+static void __init n800_cam_init(void)
+{
+	int r;
+
+	r = omap_request_gpio(N800_CAM_SENSOR_RESET_GPIO);
+	if (r < 0)
+		return;
+
+	omap_set_gpio_dataout(N800_CAM_SENSOR_RESET_GPIO, 0);
+	omap_set_gpio_direction(N800_CAM_SENSOR_RESET_GPIO, 0);
+
+	sensor_okay = 1;
+}
+
+#else
+
+static inline void n800_cam_init(void) {}
+
+#endif
+
+static struct omap_board_config_kernel n800_config[] = {
+	{ OMAP_TAG_UART,	                &n800_uart_config },
+#ifdef SUPPORT_SENSOR
+	{ OMAP_TAG_CAMERA_SENSOR,		&n800_sensor_config },
+#endif
+	{ OMAP_TAG_FBMEM,			&n800_fbmem0_config },
+	{ OMAP_TAG_FBMEM,			&n800_fbmem1_config },
+	{ OMAP_TAG_FBMEM,			&n800_fbmem2_config },
+	{ OMAP_TAG_TMP105,			&n800_tmp105_config },
+};
+
+
+static int n800_get_keyb_irq_state(struct device *dev)
+{
+	return !omap_get_gpio_datain(N800_KEYB_IRQ_GPIO);
+}
+
+static struct tsc2301_platform_data tsc2301_config = {
+	.reset_gpio	= 118,
+	.dav_gpio	= 103,
+	.pen_int_gpio	= 106,
+	.keymap = {
+		-1,		/* Event for bit 0 */
+		KEY_UP,		/* Event for bit 1 (up) */
+		KEY_F5,		/* Event for bit 2 (home) */
+		-1,		/* Event for bit 3 */
+		KEY_LEFT,	/* Event for bit 4 (left) */
+		KEY_ENTER,	/* Event for bit 5 (enter) */
+		KEY_RIGHT,	/* Event for bit 6 (right) */
+		-1,		/* Event for bit 7 */
+		KEY_ESC,	/* Event for bit 8 (cycle) */
+		KEY_DOWN,	/* Event for bit 9 (down) */
+		KEY_F4,		/* Event for bit 10 (menu) */
+		-1,		/* Event for bit 11 */
+		KEY_F8,		/* Event for bit 12 (Zoom-) */
+		KEY_F6,		/* Event for bit 13 (FS) */
+		KEY_F7,		/* Event for bit 14 (Zoom+) */
+		-1,		/* Event for bit 15 */
+	},
+	.kp_rep 	= 0,
+	.get_keyb_irq_state = n800_get_keyb_irq_state,
+};
+
+static void tsc2301_dev_init(void)
+{
+	int gpio = N800_KEYB_IRQ_GPIO;
+
+	if (omap_request_gpio(gpio) < 0) {
+		printk("can't get KBIRQ GPIO\n");
+		return;
+	}
+	omap_set_gpio_direction(gpio, 1);
+	tsc2301_config.keyb_int = OMAP_GPIO_IRQ(gpio);
+}
+
+static struct omap2_mcspi_device_config tsc2301_mcspi_config = {
+	.turbo_mode	= 0,
+	.single_channel = 1,
+};
+
+static struct omap2_mcspi_device_config mipid_mcspi_config = {
+	.turbo_mode	= 0,
+	.single_channel	= 1,
+};
+
+static struct omap2_mcspi_device_config cx3110x_mcspi_config = {
+	.turbo_mode	= 0,
+	.single_channel = 1,
+};
+
+static struct spi_board_info n800_spi_board_info[] __initdata = {
+	[0] = {
+		.modalias	= "lcd_mipid",
+		.bus_num	= 1,
+		.chip_select	= 1,
+		.max_speed_hz	= 4000000,
+		.controller_data= &mipid_mcspi_config,
+		.platform_data	= &n800_mipid_platform_data,
+	}, [1] = {
+		.modalias	= "cx3110x",
+		.bus_num	= 2,
+		.chip_select	= 0,
+		.max_speed_hz   = 48000000,
+		.controller_data= &cx3110x_mcspi_config,
+	}, [2] = {
+		.modalias	= "tsc2301",
+		.bus_num	= 1,
+		.chip_select	= 0,
+		.max_speed_hz   = 6000000,
+		.controller_data= &tsc2301_mcspi_config,
+		.platform_data  = &tsc2301_config,
+	},
+};
+
+#if defined(CONFIG_CBUS_RETU) && defined(CONFIG_LEDS_OMAP_PWM)
+
+void retu_keypad_led_set_power(struct omap_pwm_led_platform_data *self,
+			       int on_off)
+{
+	if (on_off) {
+		retu_write_reg(RETU_REG_CTRL_SET, 1 << 6);
+		msleep(2);
+		retu_write_reg(RETU_REG_CTRL_SET, 1 << 3);
+	} else {
+		retu_write_reg(RETU_REG_CTRL_CLR, (1 << 6) | (1 << 3));
+	}
+}
+
+static struct omap_pwm_led_platform_data n800_keypad_led_data = {
+	.name = "keypad",
+	.intensity_timer = 10,
+	.blink_timer = 9,
+	.set_power = retu_keypad_led_set_power,
+};
+
+static struct platform_device n800_keypad_led_device = {
+	.name		= "omap_pwm_led",
+	.id		= -1,
+	.dev		= {
+		.platform_data = &n800_keypad_led_data,
+	},
+};
+#endif
+
+#if defined(CONFIG_SPI_TSC2301_TOUCHSCREEN)
+static void __init n800_ts_set_config(void)
+{
+	const struct omap_lcd_config *conf;
+
+	conf = omap_get_config(OMAP_TAG_LCD, struct omap_lcd_config);
+	if (conf != NULL) {
+		if (strcmp(conf->panel_name, "lph8923") == 0) {
+			tsc2301_config.ts_x_plate_ohm	= 180;
+			tsc2301_config.ts_hw_avg	= 4;
+			tsc2301_config.ts_ignore_last	= 1;
+			tsc2301_config.ts_max_pressure	= 255;
+			tsc2301_config.ts_stab_time	= 100;
+		} else if (strcmp(conf->panel_name, "ls041y3") == 0) {
+			tsc2301_config.ts_x_plate_ohm	= 280;
+			tsc2301_config.ts_hw_avg	= 16;
+			tsc2301_config.ts_touch_pressure= 215;
+			tsc2301_config.ts_max_pressure	= 255;
+			tsc2301_config.ts_ignore_last	= 1;
+		} else {
+			printk(KERN_ERR "Unknown panel type, set default "
+			       "touchscreen configuration\n");
+			tsc2301_config.ts_x_plate_ohm	= 200;
+			tsc2301_config.ts_stab_time	= 100;
+		}
+	}
+}
+#else
+static inline void n800_ts_set_config(void)
+{
+}
+#endif
+
+extern void n800_mmc_slot1_cover_handler(void *arg, int state);
+
+static struct omap_gpio_switch n800_gpio_switches[] __initdata = {
+	{
+		.name			= "bat_cover",
+		.gpio			= -1,
+		.debounce_rising	= 100,
+		.debounce_falling	= 0,
+		.notify			= n800_mmc_slot1_cover_handler,
+		.notify_data		= NULL,
+	}, {
+		.name			= "headphone",
+		.gpio			= -1,
+		.debounce_rising	= 200,
+		.debounce_falling	= 200,
+	}, {
+		.name			= "cam_act",
+		.gpio			= -1,
+		.debounce_rising	= 200,
+		.debounce_falling	= 200,
+	}, {
+		.name			= "cam_turn",
+		.gpio			= -1,
+		.debounce_rising	= 100,
+		.debounce_falling	= 100,
+	},
+};
+
+static struct platform_device *n800_devices[] __initdata = {
+#if defined(CONFIG_CBUS_RETU) && defined(CONFIG_LEDS_OMAP_PWM)
+	&n800_keypad_led_device,
+#endif
+};
+
+extern void __init n800_flash_init(void);
+extern void __init n800_mmc_init(void);
+extern void __init n800_bt_init(void);
+extern void __init n800_audio_init(struct tsc2301_platform_data *);
+extern void __init n800_dsp_init(void);
+extern void __init n800_usb_init(void);
+extern void __init n800_pm_init(void);
+
+static void __init nokia_n800_init(void)
+{
+	platform_add_devices(n800_devices, ARRAY_SIZE(n800_devices));
+	n800_flash_init();
+	n800_mmc_init();
+	n800_bt_init();
+	n800_audio_init(&tsc2301_config);
+	n800_dsp_init();
+	n800_usb_init();
+	n800_cam_init();
+	n800_ts_set_config();
+	spi_register_board_info(n800_spi_board_info,
+				ARRAY_SIZE(n800_spi_board_info));
+	omap_serial_init();
+	mipid_dev_init();
+	blizzard_dev_init();
+	tsc2301_dev_init();
+	omap_register_gpio_switches(n800_gpio_switches,
+				    ARRAY_SIZE(n800_gpio_switches));
+	n800_pm_init();
+}
+
+static void __init nokia_n800_map_io(void)
+{
+	omap_board_config = n800_config;
+	omap_board_config_size = ARRAY_SIZE(n800_config);
+
+	omap2_map_common_io();
+}
+
+MACHINE_START(NOKIA_N800, "Nokia N800")
+	.phys_io	= 0x48000000,
+	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+	.boot_params	= 0x80000100,
+	.map_io		= nokia_n800_map_io,
+	.init_irq	= nokia_n800_init_irq,
+	.init_machine	= nokia_n800_init,
+	.timer		= &omap_timer,
+MACHINE_END
diff --git a/include/asm-arm/arch-omap/board.h b/include/asm-arm/arch-omap/board.h
index 18442f8..bbadf08 100644
--- a/include/asm-arm/arch-omap/board.h
+++ b/include/asm-arm/arch-omap/board.h
@@ -25,9 +25,12 @@
 #define OMAP_TAG_FBMEM		0x4f08
 #define OMAP_TAG_STI_CONSOLE	0x4f09
 #define OMAP_TAG_CAMERA_SENSOR	0x4f0a
+#define OMAP_TAG_PARTITION      0x4f0b
+#define OMAP_TAG_TEA5761	0x4f10
+#define OMAP_TAG_TMP105		0x4f11
 
 #define OMAP_TAG_BOOT_REASON    0x4f80
-#define OMAP_TAG_FLASH_PART	0x4f81
+#define OMAP_TAG_FLASH_PART_STR	0x4f81
 #define OMAP_TAG_VERSION_STR	0x4f82
 
 struct omap_clock_config {
@@ -139,8 +142,25 @@ struct omap_uart_config {
 	unsigned int enabled_uarts;
 };
 
+struct omap_tea5761_config {
+	u16 enable_gpio;
+};
+
+/* This cannot be passed from the bootloader */
+struct omap_tmp105_config {
+	u16 tmp105_irq_pin;
+	int (* set_power)(int enable);
+};
+
+struct omap_partition_config {
+	char name[16];
+	unsigned int size;
+	unsigned int offset;
+	/* same as in include/linux/mtd/partitions.h */
+	unsigned int mask_flags;
+};
 
-struct omap_flash_part_config {
+struct omap_flash_part_str_config {
 	char part_table[0];
 };
 
-- 
1.4.4.2

