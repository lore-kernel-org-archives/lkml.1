Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYEaAEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYEaAEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYEaADO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:03:14 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:59015
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753065AbYEaADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:03:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 5] xen/blkfront: add __exit to module_exit() handlers
X-Mercurial-Node: 297d1ce696670eae30a75cdb674c752f3f63a441
Message-Id: <297d1ce696670eae30a7.1212192094@localhost>
In-Reply-To: <patchbomb.1212192090@localhost>
Date: Sat, 31 May 2008 01:01:34 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1045,7 +1045,7 @@
 module_init(xlblk_init);
 
 
-static void xlblk_exit(void)
+static void __exit xlblk_exit(void)
 {
 	return xenbus_unregister_driver(&blkfront);
 }


