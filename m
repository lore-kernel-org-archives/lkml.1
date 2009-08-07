Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZHGPZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZHGPZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZHGPZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:25:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51092 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZHGPZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:25:51 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: broonie@sirena.org.uk, lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCH 2/8] Regulator: Adding header file for TPS65023
Date: Fri,  7 Aug 2009 20:55:36 +0530
Message-Id: <1249658736-10811-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
---
 include/linux/regulator/tps65023.h |   74 ++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/tps65023.h

diff --git a/include/linux/regulator/tps65023.h b/include/linux/regulator/tps65023.h
new file mode 100644
index 0000000..6afba6c
--- /dev/null
+++ b/include/linux/regulator/tps65023.h
@@ -0,0 +1,74 @@
+/*
+ * tps65023.h
+ *
+ * Header file for TI TPS65023 Regulator
+ *
+ * Copyright (C) 2009 Texas Instrument Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* Register definitions */
+#define	TPS65023_REG_VERSION		0
+#define	TPS65023_REG_PGOODZ		1
+#define	TPS65023_REG_MASK		2
+#define	TPS65023_REG_REG_CTRL		3
+#define	TPS65023_REG_CON_CTRL		4
+#define	TPS65023_REG_CON_CTRL2		5
+#define	TPS65023_REG_DEF_CORE		6
+#define	TPS65023_REG_DEFSLEW		7
+#define	TPS65023_REG_LDO_CTRL		8
+
+/* PGOODZ bitfields */
+#define	TPS65023_PGOODZ_PWRFAILZ	BIT(7)
+#define	TPS65023_PGOODZ_LOWBATTZ	BIT(6)
+#define	TPS65023_PGOODZ_VDCDC1		BIT(5)
+#define	TPS65023_PGOODZ_VDCDC2		BIT(4)
+#define	TPS65023_PGOODZ_VDCDC3		BIT(3)
+#define	TPS65023_PGOODZ_LDO2		BIT(2)
+#define	TPS65023_PGOODZ_LDO1		BIT(1)
+
+/* MASK bitfields */
+#define	TPS65023_MASK_PWRFAILZ		BIT(7)
+#define	TPS65023_MASK_LOWBATTZ		BIT(6)
+#define	TPS65023_MASK_VDCDC1		BIT(5)
+#define	TPS65023_MASK_VDCDC2		BIT(4)
+#define	TPS65023_MASK_VDCDC3		BIT(3)
+#define	TPS65023_MASK_LDO2		BIT(2)
+#define	TPS65023_MASK_LDO1		BIT(1)
+
+/* REG_CTRL bitfields */
+#define TPS65023_REG_CTRL_VDCDC1_EN	BIT(5)
+#define TPS65023_REG_CTRL_VDCDC2_EN	BIT(4)
+#define TPS65023_REG_CTRL_VDCDC3_EN	BIT(3)
+#define TPS65023_REG_CTRL_LDO2_EN	BIT(2)
+#define TPS65023_REG_CTRL_LDO1_EN	BIT(1)
+
+/* LDO_CTRL bitfields */
+#define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
+#define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0xF0 >> ((ldo_id)*4))
+
+/* Number of step-down converters available */
+#define TPS65023_NUM_DCDC		3
+/* Number of LDO voltage regulators  available */
+#define TPS65023_NUM_LDO		2
+/* Number of total regulators available */
+#define TPS65023_NUM_REGULATOR	(TPS65023_NUM_DCDC + TPS65023_NUM_LDO)
+
+/* DCDC's */
+#define TPS65023_DCDC_1			0
+#define TPS65023_DCDC_2			1
+#define TPS65023_DCDC_3			2
+/* LDOs */
+#define TPS65023_LDO_1			3
+#define TPS65023_LDO_2			4
+
+#define TPS65023_MAX_REG_ID		TPS65023_LDO_2
+
-- 
1.6.2.4

