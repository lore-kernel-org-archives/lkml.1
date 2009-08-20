Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZHTNv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZHTNv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZHTNv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:51:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36793 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbZHTNv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:51:27 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: broonie@sirena.org.uk, lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, tony@atomide.com,
       linux-i2c@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCHv2 3/3] Regulator: Adding TPS65023 and TPS6507x in Kconfig and Makefile
Date: Thu, 20 Aug 2009 19:21:05 +0530
Message-Id: <1250776265-444-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding TPS65023 and TPS6507x regulator driver support in
drivers/regulator/Makefile and drivers/regulator/Kconfig
---
 drivers/regulator/Kconfig  |   16 ++++++++++++++++
 drivers/regulator/Makefile |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..8568f3e 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -117,4 +117,20 @@ config REGULATOR_LP3971
 	 Say Y here to support the voltage regulators and convertors
 	 on National Semiconductors LP3971 PMIC
 
+config REGULATOR_TPS65023
+	tristate "TI TPS65023 Power regulators"
+	depends on I2C
+	help
+	  This driver supports TPS65023 voltage regulator chips. TPS65023 provides
+	  three step-down converters and two general-purpose LDO voltage regulators.
+	  It supports TI's software based Class-2 SmartReflex implementation.
+
+config REGULATOR_TPS6507X
+	tristate "TI TPS6507X Power regulators"
+	depends on I2C
+	help
+	  This driver supports TPS6507X voltage regulator chips. TPS6507X provides
+	  three step-down converters and two general-purpose LDO voltage regulators.
+	  It supports TI's software based Class-2 SmartReflex implementation.
+
 endif
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4d762c4..5263913 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -17,4 +17,7 @@ obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 
+obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
+obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
+
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
-- 
1.6.2.4

