Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbZHGP3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbZHGP3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZHGP3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:29:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51377 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZHGP3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:29:36 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: broonie@sirena.org.uk, lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCH 5/8] Regulator: Adding TPS65023 and TPS6507x in Kconfig and Makefile
Date: Fri,  7 Aug 2009 20:59:20 +0530
Message-Id: <1249658960-11021-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding TPS65023 and TPS6507x regulator driver support in
drivers/regulator/Makefile and drivers/regulator/Kconfig

Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
---
 drivers/regulator/Kconfig  |   16 ++++++++++++++++
 drivers/regulator/Makefile |    2 ++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..5f5b587 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -117,4 +117,20 @@ config REGULATOR_LP3971
 	 Say Y here to support the voltage regulators and convertors
 	 on National Semiconductors LP3971 PMIC
 
+config REGULATOR_TPS65023
+	tristate "TI TPS65023 Power regulators"
+	depends on OMAP3EVM_TPS65023
+	help
+	  This driver supports TPS65023 voltage regulator chips. TPS65023 provides
+	  three step-down converters and two general-purpose LDO voltage regulators.
+	  It supports TI's software based Class-2 SmartReflex implementation.
+
+config REGULATOR_TPS65073
+	tristate "TI TPS65073 Power regulators"
+	depends on OMAP3EVM_TPS65073
+	help
+	  This driver supports TPS65073 voltage regulator chips. TPS65073 provides
+	  three step-down converters and two general-purpose LDO voltage regulators.
+	  It supports TI's software based Class-2 SmartReflex implementation.
+
 endif
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4d762c4..3863e3d 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -16,5 +16,7 @@ obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
+obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
+obj-$(CONFIG_REGULATOR_TPS65073) += tps6507x-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
-- 
1.6.2.4

