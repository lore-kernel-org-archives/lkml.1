Return-Path: <linux-kernel-owner+w=401wt.eu-S933314AbZJaV1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbZJaV1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbZJaV1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:27:06 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3084 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbZJaV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:27:05 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Oct 2009 17:27:05 EDT
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linux-doc@vger.kernel.org, trivial@kernel.org,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Fix fs/debugfs/inode.c typos
Date: Sat, 31 Oct 2009 18:26:52 -0300
Message-Id: <1257024412-23427-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.5.2.250.g2bd30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 fs/debugfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index d22438e..0d23b52 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -184,7 +184,7 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
 /**
  * debugfs_create_file - create a file in the debugfs filesystem
  * @name: a pointer to a string containing the name of the file to create.
- * @mode: the permission that the file should have
+ * @mode: the permission that the file should have.
  * @parent: a pointer to the parent dentry for this file.  This should be a
  *          directory dentry if set.  If this paramater is NULL, then the
  *          file will be created in the root of the debugfs filesystem.
@@ -195,8 +195,8 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
  *        this file.
  *
  * This is the basic "create a file" function for debugfs.  It allows for a
- * wide range of flexibility in createing a file, or a directory (if you
- * want to create a directory, the debugfs_create_dir() function is
+ * wide range of flexibility in creating a file, or a directory (if you want
+ * to create a directory, the debugfs_create_dir() function is
  * recommended to be used instead.)
  *
  * This function will return a pointer to a dentry if it succeeds.  This
-- 
1.6.5.2.250.g2bd30

