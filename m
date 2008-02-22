Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYBVQ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYBVQ05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYBVQ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:26:50 -0500
Received: from mail06.svc.cra.dublin.eircom.net ([159.134.118.22]:34442 "HELO
	mail06.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755717AbYBVQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:26:49 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 11:26:48 EST
From: Mark McLoughlin <markmc@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, xen-devel@lists.xensource.com, jeremy@goop.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] xen: Add compatibility aliases for frontend drivers
Date: Fri, 22 Feb 2008 16:20:18 +0000
Message-Id: <1203697218-32064-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1203697218-32064-1-git-send-email-markmc@redhat.com>
References: <1203697218-32064-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before getting merged, xen-blkfront was xenblk and
xen-netfront was xennet.

Temporarily adding compatibility module aliases
eases upgrades from older versions by e.g. allowing
mkinitrd to find the new version of the module.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/block/xen-blkfront.c |    1 +
 drivers/net/xen-netfront.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index d0d5a02..43e1188 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -999,3 +999,4 @@ MODULE_DESCRIPTION("Xen virtual block device frontend");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(XENVBD_MAJOR);
 MODULE_ALIAS("xen:vbd");
+MODULE_ALIAS("xenblk");
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b3fa27e..e62018a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1810,3 +1810,4 @@ module_exit(netif_exit);
 MODULE_DESCRIPTION("Xen virtual network device frontend");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("xen:vif");
+MODULE_ALIAS("xennet");
-- 
1.5.4.2

