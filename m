Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbZLQSNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbZLQSNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765300AbZLQSNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:13:13 -0500
Received: from smtp.nokia.com ([192.100.122.233]:36311 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765296AbZLQSNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:13:09 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 5/6] PM: Example of how easy it is to mark attributes const
Date: Thu, 17 Dec 2009 20:12:15 +0200
Message-Id: <1261073536-27396-6-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261073536-27396-5-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-4-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-5-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 17 Dec 2009 18:11:59.0047 (UTC) FILETIME=[6CA0ED70:01CA7F44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These attributes can now be in ro sections.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 drivers/regulator/core.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index efe568d..f2b4376 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -215,7 +215,7 @@ static ssize_t regulator_uV_show(struct device *dev,
 
 	return ret;
 }
-static DEVICE_ATTR(microvolts, 0444, regulator_uV_show, NULL);
+static DEVICE_CATTR(microvolts, 0444, regulator_uV_show, NULL);
 
 static ssize_t regulator_uA_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -224,7 +224,7 @@ static ssize_t regulator_uA_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", _regulator_get_current_limit(rdev));
 }
-static DEVICE_ATTR(microamps, 0444, regulator_uA_show, NULL);
+static DEVICE_CATTR(microamps, 0444, regulator_uA_show, NULL);
 
 static ssize_t regulator_name_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
@@ -264,7 +264,7 @@ static ssize_t regulator_opmode_show(struct device *dev,
 
 	return regulator_print_opmode(buf, _regulator_get_mode(rdev));
 }
-static DEVICE_ATTR(opmode, 0444, regulator_opmode_show, NULL);
+static DEVICE_CATTR(opmode, 0444, regulator_opmode_show, NULL);
 
 static ssize_t regulator_print_state(char *buf, int state)
 {
@@ -288,7 +288,7 @@ static ssize_t regulator_state_show(struct device *dev,
 
 	return ret;
 }
-static DEVICE_ATTR(state, 0444, regulator_state_show, NULL);
+static DEVICE_CATTR(state, 0444, regulator_state_show, NULL);
 
 static ssize_t regulator_status_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
@@ -329,7 +329,7 @@ static ssize_t regulator_status_show(struct device *dev,
 
 	return sprintf(buf, "%s\n", label);
 }
-static DEVICE_ATTR(status, 0444, regulator_status_show, NULL);
+static DEVICE_CATTR(status, 0444, regulator_status_show, NULL);
 
 static ssize_t regulator_min_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -341,7 +341,7 @@ static ssize_t regulator_min_uA_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", rdev->constraints->min_uA);
 }
-static DEVICE_ATTR(min_microamps, 0444, regulator_min_uA_show, NULL);
+static DEVICE_CATTR(min_microamps, 0444, regulator_min_uA_show, NULL);
 
 static ssize_t regulator_max_uA_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -353,7 +353,7 @@ static ssize_t regulator_max_uA_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", rdev->constraints->max_uA);
 }
-static DEVICE_ATTR(max_microamps, 0444, regulator_max_uA_show, NULL);
+static DEVICE_CATTR(max_microamps, 0444, regulator_max_uA_show, NULL);
 
 static ssize_t regulator_min_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -365,7 +365,7 @@ static ssize_t regulator_min_uV_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", rdev->constraints->min_uV);
 }
-static DEVICE_ATTR(min_microvolts, 0444, regulator_min_uV_show, NULL);
+static DEVICE_CATTR(min_microvolts, 0444, regulator_min_uV_show, NULL);
 
 static ssize_t regulator_max_uV_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
@@ -377,7 +377,7 @@ static ssize_t regulator_max_uV_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", rdev->constraints->max_uV);
 }
-static DEVICE_ATTR(max_microvolts, 0444, regulator_max_uV_show, NULL);
+static DEVICE_CATTR(max_microvolts, 0444, regulator_max_uV_show, NULL);
 
 static ssize_t regulator_total_uA_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -392,7 +392,7 @@ static ssize_t regulator_total_uA_show(struct device *dev,
 	mutex_unlock(&rdev->mutex);
 	return sprintf(buf, "%d\n", uA);
 }
-static DEVICE_ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL);
+static DEVICE_CATTR(requested_microamps, 0444, regulator_total_uA_show, NULL);
 
 static ssize_t regulator_num_users_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -422,7 +422,7 @@ static ssize_t regulator_suspend_mem_uV_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", rdev->constraints->state_mem.uV);
 }
-static DEVICE_ATTR(suspend_mem_microvolts, 0444,
+static DEVICE_CATTR(suspend_mem_microvolts, 0444,
 		regulator_suspend_mem_uV_show, NULL);
 
 static ssize_t regulator_suspend_disk_uV_show(struct device *dev,
@@ -432,7 +432,7 @@ static ssize_t regulator_suspend_disk_uV_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", rdev->constraints->state_disk.uV);
 }
-static DEVICE_ATTR(suspend_disk_microvolts, 0444,
+static DEVICE_CATTR(suspend_disk_microvolts, 0444,
 		regulator_suspend_disk_uV_show, NULL);
 
 static ssize_t regulator_suspend_standby_uV_show(struct device *dev,
@@ -442,7 +442,7 @@ static ssize_t regulator_suspend_standby_uV_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", rdev->constraints->state_standby.uV);
 }
-static DEVICE_ATTR(suspend_standby_microvolts, 0444,
+static DEVICE_CATTR(suspend_standby_microvolts, 0444,
 		regulator_suspend_standby_uV_show, NULL);
 
 static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
@@ -453,7 +453,7 @@ static ssize_t regulator_suspend_mem_mode_show(struct device *dev,
 	return regulator_print_opmode(buf,
 		rdev->constraints->state_mem.mode);
 }
-static DEVICE_ATTR(suspend_mem_mode, 0444,
+static DEVICE_CATTR(suspend_mem_mode, 0444,
 		regulator_suspend_mem_mode_show, NULL);
 
 static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
@@ -464,7 +464,7 @@ static ssize_t regulator_suspend_disk_mode_show(struct device *dev,
 	return regulator_print_opmode(buf,
 		rdev->constraints->state_disk.mode);
 }
-static DEVICE_ATTR(suspend_disk_mode, 0444,
+static DEVICE_CATTR(suspend_disk_mode, 0444,
 		regulator_suspend_disk_mode_show, NULL);
 
 static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
@@ -475,7 +475,7 @@ static ssize_t regulator_suspend_standby_mode_show(struct device *dev,
 	return regulator_print_opmode(buf,
 		rdev->constraints->state_standby.mode);
 }
-static DEVICE_ATTR(suspend_standby_mode, 0444,
+static DEVICE_CATTR(suspend_standby_mode, 0444,
 		regulator_suspend_standby_mode_show, NULL);
 
 static ssize_t regulator_suspend_mem_state_show(struct device *dev,
@@ -486,7 +486,7 @@ static ssize_t regulator_suspend_mem_state_show(struct device *dev,
 	return regulator_print_state(buf,
 			rdev->constraints->state_mem.enabled);
 }
-static DEVICE_ATTR(suspend_mem_state, 0444,
+static DEVICE_CATTR(suspend_mem_state, 0444,
 		regulator_suspend_mem_state_show, NULL);
 
 static ssize_t regulator_suspend_disk_state_show(struct device *dev,
@@ -497,7 +497,7 @@ static ssize_t regulator_suspend_disk_state_show(struct device *dev,
 	return regulator_print_state(buf,
 			rdev->constraints->state_disk.enabled);
 }
-static DEVICE_ATTR(suspend_disk_state, 0444,
+static DEVICE_CATTR(suspend_disk_state, 0444,
 		regulator_suspend_disk_state_show, NULL);
 
 static ssize_t regulator_suspend_standby_state_show(struct device *dev,
@@ -508,7 +508,7 @@ static ssize_t regulator_suspend_standby_state_show(struct device *dev,
 	return regulator_print_state(buf,
 			rdev->constraints->state_standby.enabled);
 }
-static DEVICE_ATTR(suspend_standby_state, 0444,
+static DEVICE_CATTR(suspend_standby_state, 0444,
 		regulator_suspend_standby_state_show, NULL);
 
 
-- 
1.6.0.4

