Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbZKRQZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbZKRQZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZKRQZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:25:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395AbZKRQZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:25:45 -0500
Date: Wed, 18 Nov 2009 17:25:51 +0100
From: Jan Blunck <jblunck@suse.de>
To: Andreas Dilger <adilger@sun.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Explicitly assign values to on-disk enum of filetypes
Message-ID: <20091118162550.GP21750@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an old patch that I found in my tree. Andreas, it seems that this is
something you proposed.

Comments?
	Jan

>From 290d3d969850ff9555bc213035b1c4e401ea9ada Mon Sep 17 00:00:00 2001
From: Jan Blunck <jblunck@suse.de>
Date: Wed, 18 Nov 2009 17:10:56 +0100
Subject: [PATCH] ext2: Explicitly assign values to on-disk enum of filetypes

It is somewhat dangerous to use a straight enum here, because this will
reassign values of later variables if one of the earlier ones is removed.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Andreas Dilger <adilger@sun.com>
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
1.6.4.2

