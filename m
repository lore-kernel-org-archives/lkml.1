Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZDOJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZDOJLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZDOJLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:11:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZDOJLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:11:36 -0400
Date: Wed, 15 Apr 2009 17:11:26 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Yan Zheng <zheng.yan@oracle.com>
Cc: linux-kernel@vger.kernel.org, eugeneteo@kernel.sg
Subject: [PATCH] Btrfs: setting variable out of order
Message-ID: <20090415091126.GA13323@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't look intentional.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/btrfs/ctree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e5b2533..6aa2468 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3376,8 +3376,8 @@ int btrfs_insert_some_items(struct
btrfs_trans_handle *trans,
        for (i = 0; i < nr; i++) {
                if (total_size + data_size[i] + sizeof(struct btrfs_item) >
                    BTRFS_LEAF_DATA_SIZE(root)) {
-                       break;
                        nr = i;
+                       break;
               	}
                total_data += data_size[i];
                total_size += data_size[i] + sizeof(struct btrfs_item);
