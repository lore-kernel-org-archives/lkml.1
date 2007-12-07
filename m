Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbXLGRxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbXLGRxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbXLGRuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:50:25 -0500
Received: from ns1.co-raid.com ([65.14.39.133]:21123 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756434AbXLGRuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:50:23 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 11/13] remove extra space in prototypes for consistency
Date: Fri,  7 Dec 2007 12:48:09 -0500
Message-Id: <1197049691-27462-11-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
References: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra space in prototypes for consistency.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 7168d3d..98ab170 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -15,7 +15,7 @@
 
 static struct kmem_cache *buf_pool_cache;
 
-static ssize_t aoedisk_show_state(struct gendisk * disk, char *page)
+static ssize_t aoedisk_show_state(struct gendisk *disk, char *page)
 {
 	struct aoedev *d = disk->private_data;
 
@@ -26,7 +26,7 @@ static ssize_t aoedisk_show_state(struct gendisk * disk, char *page)
 			(d->nopen && !(d->flags & DEVFL_UP)) ? ",closewait" : "");
 	/* I'd rather see nopen exported so we can ditch closewait */
 }
-static ssize_t aoedisk_show_mac(struct gendisk * disk, char *page)
+static ssize_t aoedisk_show_mac(struct gendisk *disk, char *page)
 {
 	struct aoedev *d = disk->private_data;
 	struct aoetgt *t = d->targets[0];
@@ -35,7 +35,7 @@ static ssize_t aoedisk_show_mac(struct gendisk * disk, char *page)
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
1.5.3.4

