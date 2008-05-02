Return-Path: <linux-kernel-owner+w=401wt.eu-S965405AbYEBP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405AbYEBP5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965010AbYEBPwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:52:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38986 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964829AbYEBPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:51:53 -0400
Subject: [PATCH 04/13] regulator: fixed regulator interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 16:41:54 +0100
Message-Id: <1209742914.12502.45.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for fixed regulators. This class of regulator is
not software controllable but can coexist on machines with software
controllable regulators.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 include/linux/regulator/fixed.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/regulator/fixed.h

diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
new file mode 100644
index 0000000..1387a5d
--- /dev/null
+++ b/include/linux/regulator/fixed.h
@@ -0,0 +1,22 @@
+/*
+ * fixed.h
+ *
+ * Copyright 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#ifndef __REGULATOR_FIXED_H
+#define __REGULATOR_FIXED_H
+
+struct fixed_voltage_config {
+	const char *supply_name;
+	int microvolts;
+};
+
+#endif
-- 
1.5.4.3


