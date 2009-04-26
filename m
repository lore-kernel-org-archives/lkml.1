Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZDZIu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZDZIu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 04:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZDZIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 04:50:18 -0400
Received: from cathcart.site5.com ([74.54.107.137]:35814 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZDZIuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 04:50:16 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] regulator/virtual: fix strings compare predicates
Date: Sun, 26 Apr 2009 11:49:30 +0300
Message-Id: <1240735770-10265-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/virtual.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 3d08348..71403fa 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -230,13 +230,13 @@ static ssize_t set_mode(struct device *dev, struct device_attribute *attr,
 	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
 	 * will be shared with show_mode(), above.
 	 */
-	if (sysfs_streq(buf, "fast\n") == 0)
+	if (sysfs_streq(buf, "fast\n"))
 		mode = REGULATOR_MODE_FAST;
-	else if (sysfs_streq(buf, "normal\n") == 0)
+	else if (sysfs_streq(buf, "normal\n"))
 		mode = REGULATOR_MODE_NORMAL;
-	else if (sysfs_streq(buf, "idle\n") == 0)
+	else if (sysfs_streq(buf, "idle\n"))
 		mode = REGULATOR_MODE_IDLE;
-	else if (sysfs_streq(buf, "standby\n") == 0)
+	else if (sysfs_streq(buf, "standby\n"))
 		mode = REGULATOR_MODE_STANDBY;
 	else {
 		dev_err(dev, "Configuring invalid mode\n");
-- 
1.5.6.4

