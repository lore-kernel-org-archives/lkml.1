Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157Ab0ADSFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0ADSFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122Ab0ADSFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:05:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42713 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751941Ab0ADSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:05:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 2.6.33] mfd: Correct WM835x ISINK ramp time defines
Date: Mon,  4 Jan 2010 18:05:00 +0000
Message-Id: <1262628300-18018-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The constants used to specify ISINK ramp times for WM835x had the
wrong shifts so that the on times applied to the off ramp and vice
versa. The masks for the bitfields are correct.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 include/linux/mfd/wm8350/pmic.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mfd/wm8350/pmic.h b/include/linux/mfd/wm8350/pmic.h
index be3264e..e786fe9 100644
--- a/include/linux/mfd/wm8350/pmic.h
+++ b/include/linux/mfd/wm8350/pmic.h
@@ -666,20 +666,20 @@
 #define WM8350_ISINK_FLASH_DUR_64MS		(1 << 8)
 #define WM8350_ISINK_FLASH_DUR_96MS		(2 << 8)
 #define WM8350_ISINK_FLASH_DUR_1024MS		(3 << 8)
-#define WM8350_ISINK_FLASH_ON_INSTANT		(0 << 4)
-#define WM8350_ISINK_FLASH_ON_0_25S		(1 << 4)
-#define WM8350_ISINK_FLASH_ON_0_50S		(2 << 4)
-#define WM8350_ISINK_FLASH_ON_1_00S		(3 << 4)
-#define WM8350_ISINK_FLASH_ON_1_95S		(1 << 4)
-#define WM8350_ISINK_FLASH_ON_3_91S		(2 << 4)
-#define WM8350_ISINK_FLASH_ON_7_80S		(3 << 4)
-#define WM8350_ISINK_FLASH_OFF_INSTANT		(0 << 0)
-#define WM8350_ISINK_FLASH_OFF_0_25S		(1 << 0)
-#define WM8350_ISINK_FLASH_OFF_0_50S		(2 << 0)
-#define WM8350_ISINK_FLASH_OFF_1_00S		(3 << 0)
-#define WM8350_ISINK_FLASH_OFF_1_95S		(1 << 0)
-#define WM8350_ISINK_FLASH_OFF_3_91S		(2 << 0)
-#define WM8350_ISINK_FLASH_OFF_7_80S		(3 << 0)
+#define WM8350_ISINK_FLASH_ON_INSTANT		(0 << 0)
+#define WM8350_ISINK_FLASH_ON_0_25S		(1 << 0)
+#define WM8350_ISINK_FLASH_ON_0_50S		(2 << 0)
+#define WM8350_ISINK_FLASH_ON_1_00S		(3 << 0)
+#define WM8350_ISINK_FLASH_ON_1_95S		(1 << 0)
+#define WM8350_ISINK_FLASH_ON_3_91S		(2 << 0)
+#define WM8350_ISINK_FLASH_ON_7_80S		(3 << 0)
+#define WM8350_ISINK_FLASH_OFF_INSTANT		(0 << 4)
+#define WM8350_ISINK_FLASH_OFF_0_25S		(1 << 4)
+#define WM8350_ISINK_FLASH_OFF_0_50S		(2 << 4)
+#define WM8350_ISINK_FLASH_OFF_1_00S		(3 << 4)
+#define WM8350_ISINK_FLASH_OFF_1_95S		(1 << 4)
+#define WM8350_ISINK_FLASH_OFF_3_91S		(2 << 4)
+#define WM8350_ISINK_FLASH_OFF_7_80S		(3 << 4)
 
 /*
  * Regulator Interrupts.
-- 
1.6.5.7

