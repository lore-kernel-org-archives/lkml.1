Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYJFMil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYJFMil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYJFMiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:38:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40056 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753030AbYJFMiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:38:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 07/13] mfd: Add WM8350 watchdog register definitions
Date: Mon,  6 Oct 2008 13:38:02 +0100
Message-Id: <1223296688-9960-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223296688-9960-6-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main>
 <1223296688-9960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-6-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8350/wdt.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mfd/wm8350/wdt.h

diff --git a/include/linux/mfd/wm8350/wdt.h b/include/linux/mfd/wm8350/wdt.h
new file mode 100644
index 0000000..72fc9f5
--- /dev/null
+++ b/include/linux/mfd/wm8350/wdt.h
@@ -0,0 +1,22 @@
+/*
+ * wdt.h  --  Watchdog Driver for Wolfson WM8350 PMIC
+ *
+ * Copyright 2007 Wolfson Microelectronics PLC
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#ifndef __LINUX_MFD_WM8350_WDT_H_
+#define __LINUX_MFD_WM8350_WDT_H_
+
+#define WM8350_WDOG_HIB_MODE                    0x0080
+#define WM8350_WDOG_DEBUG                       0x0040
+#define WM8350_WDOG_MODE_MASK                   0x0030
+#define WM8350_WDOG_TO_MASK                     0x0007
+
+#define WM8350_IRQ_SYS_WDOG_TO			24
+
+#endif
-- 
1.5.6.5

