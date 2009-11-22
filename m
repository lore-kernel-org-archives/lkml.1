Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbZKVIQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbZKVIQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZKVIQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:16:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:46271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbZKVIQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:16:17 -0500
Subject: [PATCH] PM: Fix kernel-doc notation
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:43:57 +0530
Message-Id: <1258877637.4495.45.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following htmldocs warnings:

  Warning(drivers/base/power/main.c:249): No description found for parameter 'master'
  Warning(drivers/base/power/main.c:249): Excess function parameter 'slave' description in 'device_pm_wait_for_slaves'
  Warning(drivers/base/power/main.c:292): No description found for parameter 'master'
  Warning(drivers/base/power/main.c:292): Excess function parameter 'slave' description in 'device_pm_check_slaves'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/power/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index e8d1ea6..5f13084 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -243,7 +243,7 @@ static void device_pm_wait_for_masters(struct device *slave)
 
 /**
  * device_pm_wait_for_slaves - Wait for all slaves of given device.
- * @slave: Device to wait for the slaves of.
+ * @master: Device to wait for the slaves of.
  */
 static void device_pm_wait_for_slaves(struct device *master)
 {
@@ -286,7 +286,7 @@ static int device_pm_check_masters(struct device *slave)
 
 /**
  * device_pm_check_slaves - Check power.op_complete for slaves of a device.
- * @slave: Device to check the slaves of.
+ * @master: Device to check the slaves of.
  */
 static int device_pm_check_slaves(struct device *master)
 {
-- 
1.6.5.3


