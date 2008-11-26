Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYKZT0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYKZT0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYKZTZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:25:55 -0500
Received: from styx.suse.cz ([82.119.242.94]:47233 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbYKZTZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:25:54 -0500
Date: Wed, 26 Nov 2008 20:25:53 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] quota: Merge lines in quotaops.
Message-ID: <20081126192553.GJ23124@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

---
 include/linux/quotaops.h |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 04a130f..2707973 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -412,39 +412,33 @@ static inline void vfs_dq_free_space(struct inode *inode, qsize_t nr)
 
 static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space_nodirty(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_prealloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_prealloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
- 	return vfs_dq_alloc_space_nodirty(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_alloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 
 static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_alloc_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_alloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_reserve_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_reserve_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_claim_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_claim_space(inode, nr << inode->i_blkbits);
 }
 
 static inline
-- 
1.6.0.4

