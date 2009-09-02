Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZIBOC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZIBOC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZIBOCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:02:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbZIBN72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:28 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de, Jan Kara <jack@suse.cz>,
       linux-ext4@vger.kernel.org
Subject: [PATCH 08/16] ext2: Update comment about generic_osync_inode
Date: Wed,  2 Sep 2009 15:59:18 +0200
Message-Id: <1251899966-7316-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We rely on generic_write_sync() now.

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e271303..1c1638f 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -482,7 +482,7 @@ static int ext2_alloc_branch(struct inode *inode,
 		unlock_buffer(bh);
 		mark_buffer_dirty_inode(bh, inode);
 		/* We used to sync bh here if IS_SYNC(inode).
-		 * But we now rely upon generic_osync_inode()
+		 * But we now rely upon generic_write_sync()
 		 * and b_inode_buffers.  But not for directories.
 		 */
 		if (S_ISDIR(inode->i_mode) && IS_DIRSYNC(inode))
-- 
1.6.0.2

