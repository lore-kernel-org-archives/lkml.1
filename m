Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbXFZTIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbXFZTIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbXFZTFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:51 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25150 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759557AbXFZTFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:50 -0400
Message-Id: <39c2dcbfa61df3a06c9d15074966c828ee8ae9b0.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:12 -0400
Subject: [PATCH 11/12] remove extra space in prototypes for consistency
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra space in prototypes for consistency.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index c9cf576..ccadd9a 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -14,7 +14,7 @@
 
 static struct kmem_cache *buf_pool_cache;
 
-static ssize_t aoedisk_show_state(struct gendisk * disk, char *page)
+static ssize_t aoedisk_show_state(struct gendisk *disk, char *page)
 {
 	struct aoedev *d = disk->private_data;
 
@@ -25,7 +25,7 @@ static ssize_t aoedisk_show_state(struct gendisk * disk, char *page)
 			(d->nopen && !(d->flags & DEVFL_UP)) ? ",closewait" : "");
 	/* I'd rather see nopen exported so we can ditch closewait */
 }
-static ssize_t aoedisk_show_mac(struct gendisk * disk, char *page)
+static ssize_t aoedisk_show_mac(struct gendisk *disk, char *page)
 {
 	struct aoedev *d = disk->private_data;
 	struct aoetgt *t = d->targets[0];
@@ -34,7 +34,7 @@ static ssize_t aoedisk_show_mac(struct gendisk * disk, char *page)
 		return snprintf(page, PAGE_SIZE, "none\n");
 	return snprintf(page, PAGE_SIZE, "%012llx\n", mac_addr(t->addr));
 }
-static ssize_t aoedisk_show_netif(struct gendisk * disk, char *page)
+static ssize_t aoedisk_show_netif(struct gendisk *disk, char *page)
 {
 	struct aoedev *d = disk->private_data;
 	struct net_device *nds[8], **nd, **nnd, **ne;
@@ -71,7 +71,7 @@ static ssize_t aoedisk_show_netif(struct gendisk * disk, char *page)
 	return p-page;
 }
 /* firmware version */
-static ssize_t aoedisk_show_fwver(struct gendisk * disk, char *page)
+static ssize_t aoedisk_show_fwver(struct gendisk *disk, char *page)
 {
 	struct aoedev *d = disk->private_data;
 
-- 
1.5.2.1

