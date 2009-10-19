Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZJSMKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZJSMKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZJSMKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:10:49 -0400
Received: from smtp.nokia.com ([192.100.122.230]:20544 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZJSMKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:10:49 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: sameo@linux.intel.com, linux-omap@vger.kernel.org
Subject: [PATCH 1/5] mfd: twl4030-power: Rename DEVGROUP to DEV_GRP
Date: Mon, 19 Oct 2009 15:10:44 +0300
Message-Id: <1255954244-28873-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 19 Oct 2009 12:10:43.0640 (UTC) FILETIME=[2EB50B80:01CA50B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stick to the names used in the reference manual

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/twl4030-power.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index d423e0c..82e3bcb 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -69,12 +69,12 @@ static u8 twl4030_start_script_address = 0x2b;
 
 /* resource configuration registers */
 
-#define DEVGROUP_OFFSET		0
+#define DEV_GRP_OFFSET		0
 #define TYPE_OFFSET		1
 
-/* Bit positions */
-#define DEVGROUP_SHIFT		5
-#define DEVGROUP_MASK		(7 << DEVGROUP_SHIFT)
+/* Bit positions in the registers */
+#define DEV_GRP_SHIFT		5
+#define DEV_GRP_MASK		(7 << DEV_GRP_SHIFT)
 #define TYPE_SHIFT		0
 #define TYPE_MASK		(7 << TYPE_SHIFT)
 #define TYPE2_SHIFT		3
@@ -328,7 +328,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 
 	/* Set resource group */
 	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &grp,
-				rconfig_addr + DEVGROUP_OFFSET);
+				rconfig_addr + DEV_GRP_OFFSET);
 	if (err) {
 		pr_err("TWL4030 Resource %d group could not be read\n",
 			rconfig->resource);
@@ -336,10 +336,10 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 	}
 
 	if (rconfig->devgroup >= 0) {
-		grp &= ~DEVGROUP_MASK;
-		grp |= rconfig->devgroup << DEVGROUP_SHIFT;
+		grp &= ~DEV_GRP_MASK;
+		grp |= rconfig->devgroup << DEV_GRP_SHIFT;
 		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
-					grp, rconfig_addr + DEVGROUP_OFFSET);
+					grp, rconfig_addr + DEV_GRP_OFFSET);
 		if (err < 0) {
 			pr_err("TWL4030 failed to program devgroup\n");
 			return err;
-- 
1.6.3.3

