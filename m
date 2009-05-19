Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZESKAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZESKAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZESKAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:00:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:38670 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZESKAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:00:39 -0400
Date: Tue, 19 May 2009 12:00:38 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] ext2: Explicitly assign values to on-disk enum of filetypes
Message-ID: <20090519100038.GJ16526@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is somewhat dangerous to use a straight enum here, because this will
reassign values of later variables if one of the earlier ones is removed.

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 include/linux/ext2_fs.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 121720d..2dfa707 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -565,14 +565,14 @@ struct ext2_dir_entry_2 {
  * other bits are reserved for now.
  */
 enum {
-	EXT2_FT_UNKNOWN,
-	EXT2_FT_REG_FILE,
-	EXT2_FT_DIR,
-	EXT2_FT_CHRDEV,
-	EXT2_FT_BLKDEV,
-	EXT2_FT_FIFO,
-	EXT2_FT_SOCK,
-	EXT2_FT_SYMLINK,
+	EXT2_FT_UNKNOWN		= 0,
+	EXT2_FT_REG_FILE	= 1,
+	EXT2_FT_DIR		= 2,
+	EXT2_FT_CHRDEV		= 3,
+	EXT2_FT_BLKDEV		= 4,
+	EXT2_FT_FIFO		= 5,
+	EXT2_FT_SOCK		= 6,
+	EXT2_FT_SYMLINK		= 7,
 	EXT2_FT_MAX
 };
 
-- 
1.6.1.3

