Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYDBSmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYDBSmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbYDBSfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:54 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38419 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758004AbYDBSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 17 of 24] xen: Add compatibility aliases for frontend drivers
X-Mercurial-Node: d188df7879a671d3282d077e1dc63033b003797e
Message-Id: <d188df7879a671d3282d.1207158846@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:54:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Before getting merged, xen-blkfront was xenblk and
xen-netfront was xennet.

Temporarily adding compatibility module aliases
eases upgrades from older versions by e.g. allowing
mkinitrd to find the new version of the module.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/block/xen-blkfront.c |    1 +
 drivers/net/xen-netfront.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1016,3 +1016,4 @@
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(XENVBD_MAJOR);
 MODULE_ALIAS("xen:vbd");
+MODULE_ALIAS("xenblk");
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1810,3 +1810,4 @@
 MODULE_DESCRIPTION("Xen virtual network device frontend");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("xen:vif");
+MODULE_ALIAS("xennet");


