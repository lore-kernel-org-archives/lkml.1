Return-Path: <linux-kernel-owner+w=401wt.eu-S1750735AbXBKREs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750735AbXBKREs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXBKREs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:04:48 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:9127 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXBKREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:04:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=c8FcDWk0QylA4h0ZNDRD0AONNRgeeOAOO2pmzFkEo9sddHXXaQTLGint2M1DdTRAceifyhfAvyhSvjASJ+9UN8APwZxV5KUZ+apqTr4x5wAPTFShQSY1vpZi3ilO1Pmr+qKz2tapDGjZnZ30kvisn/qI8QKfOMK7VC9bI3z+Zts=
From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>
Subject: [PATCH] Update documentation
Date: Sun, 11 Feb 2007 22:34:39 +0530
Message-Id: <11712134791925-git-send-email-aneesh.kumar@gmail.com>
X-Mailer: git-send-email 1.5.0.rc4.16.g9e258-dirty
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>

Signed-off-by: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>
---
 fs/ext2/balloc.c |    2 +-
 fs/ext3/balloc.c |    2 +-
 fs/ext4/balloc.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index b1981d0..baf71dd 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -29,7 +29,7 @@
  * The file system contains group descriptors which are located after the
  * super block.  Each descriptor contains the number of the bitmap block and
  * the free blocks count in the block.  The descriptors are loaded in memory
- * when a file system is mounted (see ext2_read_super).
+ * when a file system is mounted (see ext2_fill_super).
  */
 
 
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 2216174..ca8aee6 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -32,7 +32,7 @@
  * The file system contains group descriptors which are located after the
  * super block.  Each descriptor contains the number of the bitmap block and
  * the free blocks count in the block.  The descriptors are loaded in memory
- * when a file system is mounted (see ext3_read_super).
+ * when a file system is mounted (see ext3_fill_super).
  */
 
 
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index c4dd110..8a23483 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -50,7 +50,7 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
  * The file system contains group descriptors which are located after the
  * super block.  Each descriptor contains the number of the bitmap block and
  * the free blocks count in the block.  The descriptors are loaded in memory
- * when a file system is mounted (see ext4_read_super).
+ * when a file system is mounted (see ext4_fill_super).
  */
 
 
-- 
1.5.0.rc4.16.g9e258-dirty

