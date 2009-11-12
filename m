Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbZKLSr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbZKLSr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZKLSru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:47:50 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26649 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZKLSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:47:47 -0500
Subject: [PATCH 01/11] cciss: Make device attributes static
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:14 -0600
Message-ID: <20091112184914.23389.57000.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

cciss: Make device attributes static

Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6399e50..92b1263 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -482,7 +482,7 @@ static ssize_t host_store_rescan(struct device *dev,
 
 	return count;
 }
-DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
+static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
 static ssize_t dev_show_unique_id(struct device *dev,
 				 struct device_attribute *attr,
@@ -512,7 +512,7 @@ static ssize_t dev_show_unique_id(struct device *dev,
 				sn[8], sn[9], sn[10], sn[11],
 				sn[12], sn[13], sn[14], sn[15]);
 }
-DEVICE_ATTR(unique_id, S_IRUGO, dev_show_unique_id, NULL);
+static DEVICE_ATTR(unique_id, S_IRUGO, dev_show_unique_id, NULL);
 
 static ssize_t dev_show_vendor(struct device *dev,
 			       struct device_attribute *attr,
@@ -536,7 +536,7 @@ static ssize_t dev_show_vendor(struct device *dev,
 	else
 		return snprintf(buf, sizeof(vendor) + 1, "%s\n", drv->vendor);
 }
-DEVICE_ATTR(vendor, S_IRUGO, dev_show_vendor, NULL);
+static DEVICE_ATTR(vendor, S_IRUGO, dev_show_vendor, NULL);
 
 static ssize_t dev_show_model(struct device *dev,
 			      struct device_attribute *attr,
@@ -560,7 +560,7 @@ static ssize_t dev_show_model(struct device *dev,
 	else
 		return snprintf(buf, sizeof(model) + 1, "%s\n", drv->model);
 }
-DEVICE_ATTR(model, S_IRUGO, dev_show_model, NULL);
+static DEVICE_ATTR(model, S_IRUGO, dev_show_model, NULL);
 
 static ssize_t dev_show_rev(struct device *dev,
 			    struct device_attribute *attr,
@@ -584,7 +584,7 @@ static ssize_t dev_show_rev(struct device *dev,
 	else
 		return snprintf(buf, sizeof(rev) + 1, "%s\n", drv->rev);
 }
-DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
+static DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
 
 static ssize_t cciss_show_lunid(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -609,7 +609,7 @@ static ssize_t cciss_show_lunid(struct device *dev,
 		lunid[0], lunid[1], lunid[2], lunid[3],
 		lunid[4], lunid[5], lunid[6], lunid[7]);
 }
-DEVICE_ATTR(lunid, S_IRUGO, cciss_show_lunid, NULL);
+static DEVICE_ATTR(lunid, S_IRUGO, cciss_show_lunid, NULL);
 
 static ssize_t cciss_show_raid_level(struct device *dev,
 				     struct device_attribute *attr, char *buf)
@@ -632,7 +632,7 @@ static ssize_t cciss_show_raid_level(struct device *dev,
 	return snprintf(buf, strlen(raid_label[raid]) + 7, "RAID %s\n",
 			raid_label[raid]);
 }
-DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
+static DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
 
 static ssize_t cciss_show_usage_count(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -651,7 +651,7 @@ static ssize_t cciss_show_usage_count(struct device *dev,
 	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 	return snprintf(buf, 20, "%d\n", count);
 }
-DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
+static DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
 
 static struct attribute *cciss_host_attrs[] = {
 	&dev_attr_rescan.attr,

