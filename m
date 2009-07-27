Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZG0Ntf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZG0Ntf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZG0Nte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:49:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59135 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754622AbZG0Nq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/22] mfd: Hook WM831x into build system
Date: Mon, 27 Jul 2009 14:45:58 +0100
Message-Id: <1248702372-29534-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig  |   10 ++++++++++
 drivers/mfd/Makefile |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 491ac0f..0273456 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -157,6 +157,16 @@ config MFD_WM8400
 	  the device, additional drivers must be enabled in order to use
 	  the functionality of the device.
 
+config MFD_WM831X
+	tristate "Support Wolfson Microelectronics WM831x PMICs"
+	select MFD_CORE
+	depends on I2C
+	help
+	  Support for the Wolfson Microelecronics WM831x PMICs.  This
+	  driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
 config MFD_WM8350
 	tristate
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 6f8a9a1..285cb32 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -15,6 +15,8 @@ obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o
 obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o
 
 obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
+wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
+obj-$(CONFIG_MFD_WM831X)	+= wm831x.o
 wm8350-objs			:= wm8350-core.o wm8350-regmap.o wm8350-gpio.o
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
-- 
1.6.3.3

