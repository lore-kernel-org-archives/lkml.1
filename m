Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZCDSeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZCDSeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZCDSdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:33:55 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59554 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZCDSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:33:54 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 1/3] xfs: move declaration to header file
To: Felix Blyakher <felixb@sgi.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Date: Wed, 04 Mar 2009 19:33:48 +0100
Message-ID: <20090304183331.525.4491.stgit@f10box.hanneseder.net>
In-Reply-To: <20090304183136.525.13769.stgit@f10box.hanneseder.net>
References: <20090304183136.525.13769.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  fs/xfs/xfs_da_btree.c:1550:26: warning: symbol 'xfs_default_nameops' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 fs/xfs/xfs_da_btree.h |    1 +
 fs/xfs/xfs_dir2.c     |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 9d5a7e8..41f27b3 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -268,5 +268,6 @@ xfs_daddr_t xfs_da_blkno(xfs_dabuf_t *dabuf);
 
 extern struct kmem_zone *xfs_da_state_zone;
 extern struct kmem_zone *xfs_dabuf_zone;
+extern const struct xfs_nameops xfs_default_nameops;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 1afb122..c657bec 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -46,8 +46,6 @@
 
 struct xfs_name xfs_name_dotdot = {"..", 2};
 
-extern const struct xfs_nameops xfs_default_nameops;
-
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
  * used in IRIX.

