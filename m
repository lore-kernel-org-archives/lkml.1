Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbYAVDTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbYAVDTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbYAVDHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:07:42 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65238 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758393AbYAVDHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:07:39 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 38/49] ext4: fix up EXT4FS_DEBUG builds
Date: Mon, 21 Jan 2008 22:02:17 -0500
Message-Id: <1200970948-17903-39-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-38-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
 <1200970948-17903-38-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Builds with EXT4FS_DEBUG defined (to enable ext4_debug()) fail
without these changes.  Clean up some format warnings too.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/balloc.c |    6 +++---
 fs/ext4/ialloc.c |    2 +-
 fs/ext4/resize.c |   16 ++++++++--------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 925e063..54d3da7 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1630,7 +1630,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 
 	sbi = EXT4_SB(sb);
 	es = EXT4_SB(sb)->s_es;
-	ext4_debug("goal=%lu.\n", goal);
+	ext4_debug("goal=%llu.\n", goal);
 	/*
 	 * Allocate a block from reservation only when
 	 * filesystem is mounted with reservation(default,-o reservation), and
@@ -1740,7 +1740,7 @@ retry_alloc:
 
 allocated:
 
-	ext4_debug("using block group %d(%d)\n",
+	ext4_debug("using block group %lu(%d)\n",
 			group_no, gdp->bg_free_blocks_count);
 
 	BUFFER_TRACE(gdp_bh, "get_write_access");
@@ -1898,7 +1898,7 @@ ext4_fsblk_t ext4_count_free_blocks(struct super_block *sb)
 	brelse(bitmap_bh);
 	printk("ext4_count_free_blocks: stored = %llu"
 		", computed = %llu, %llu\n",
-	       EXT4_FREE_BLOCKS_COUNT(es),
+		ext4_free_blocks_count(es),
 		desc_count, bitmap_count);
 	return bitmap_count;
 #else
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 17b5df1..575b521 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -857,7 +857,7 @@ unsigned long ext4_count_free_inodes (struct super_block * sb)
 			continue;
 
 		x = ext4_count_free(bitmap_bh, EXT4_INODES_PER_GROUP(sb) / 8);
-		printk("group %d: stored = %d, counted = %lu\n",
+		printk(KERN_DEBUG "group %lu: stored = %d, counted = %lu\n",
 			i, le16_to_cpu(gdp->bg_free_inodes_count), x);
 		bitmap_count += x;
 	}
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 7090c2d..4fbba60 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -206,7 +206,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	}
 
 	if (ext4_bg_has_super(sb, input->group)) {
-		ext4_debug("mark backup superblock %#04lx (+0)\n", start);
+		ext4_debug("mark backup superblock %#04llx (+0)\n", start);
 		ext4_set_bit(0, bh->b_data);
 	}
 
@@ -215,7 +215,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	     i < gdblocks; i++, block++, bit++) {
 		struct buffer_head *gdb;
 
-		ext4_debug("update backup group %#04lx (+%d)\n", block, bit);
+		ext4_debug("update backup group %#04llx (+%d)\n", block, bit);
 
 		if ((err = extend_or_restart_transaction(handle, 1, bh)))
 			goto exit_bh;
@@ -243,7 +243,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	     i < reserved_gdb; i++, block++, bit++) {
 		struct buffer_head *gdb;
 
-		ext4_debug("clear reserved block %#04lx (+%d)\n", block, bit);
+		ext4_debug("clear reserved block %#04llx (+%d)\n", block, bit);
 
 		if ((err = extend_or_restart_transaction(handle, 1, bh)))
 			goto exit_bh;
@@ -256,10 +256,10 @@ static int setup_new_group_blocks(struct super_block *sb,
 		ext4_set_bit(bit, bh->b_data);
 		brelse(gdb);
 	}
-	ext4_debug("mark block bitmap %#04x (+%ld)\n", input->block_bitmap,
+	ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
 		   input->block_bitmap - start);
 	ext4_set_bit(input->block_bitmap - start, bh->b_data);
-	ext4_debug("mark inode bitmap %#04x (+%ld)\n", input->inode_bitmap,
+	ext4_debug("mark inode bitmap %#04llx (+%llu)\n", input->inode_bitmap,
 		   input->inode_bitmap - start);
 	ext4_set_bit(input->inode_bitmap - start, bh->b_data);
 
@@ -268,7 +268,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	     i < sbi->s_itb_per_group; i++, bit++, block++) {
 		struct buffer_head *it;
 
-		ext4_debug("clear inode block %#04lx (+%d)\n", block, bit);
+		ext4_debug("clear inode block %#04llx (+%d)\n", block, bit);
 
 		if ((err = extend_or_restart_transaction(handle, 1, bh)))
 			goto exit_bh;
@@ -291,7 +291,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	brelse(bh);
 
 	/* Mark unused entries in inode bitmap used */
-	ext4_debug("clear inode bitmap %#04x (+%ld)\n",
+	ext4_debug("clear inode bitmap %#04llx (+%llu)\n",
 		   input->inode_bitmap, input->inode_bitmap - start);
 	if (IS_ERR(bh = bclean(handle, sb, input->inode_bitmap))) {
 		err = PTR_ERR(bh);
@@ -1054,7 +1054,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
 	sb->s_dirt = 1;
 	unlock_super(sb);
-	ext4_debug("freeing blocks %lu through %llu\n", o_blocks_count,
+	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
 	ext4_free_blocks_sb(handle, sb, o_blocks_count, add, &freed_blocks);
 	ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
-- 
1.5.4.rc3.31.g1271-dirty

