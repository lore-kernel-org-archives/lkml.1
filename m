Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588Ab0AUE2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0AUE2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487Ab0AUE1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:27:52 -0500
Received: from kroah.org ([198.145.64.141]:60081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0AUEWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:34 2010
Message-Id: <20100121041834.299422387@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [14/30] mfd: Correct WM835x ISINK ramp time defines
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 9dffe2a32b0deef52605d50527c0d240b15cabf7 upstream.

The constants used to specify ISINK ramp times for WM835x had the
wrong shifts so that the on times applied to the off ramp and vice
versa. The masks for the bitfields are correct.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mfd/wm8350/pmic.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

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


