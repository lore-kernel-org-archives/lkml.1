Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbXGDXaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbXGDXaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXGDXaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:30:08 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40027 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbXGDXaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:30:07 -0400
Date: Wed, 4 Jul 2007 19:30:03 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix trivial typos in anon_inodes.c comments
Message-ID: <20070704233003.GH26764@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Trivial typo and grammar fixes.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/anon_inodes.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 40fe3a3..a260198 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -53,7 +53,7 @@ static struct dentry_operations anon_inodefs_dentry_operations = {
 };
 
 /**
- * anon_inode_getfd - creates a new file instance by hooking it up to and
+ * anon_inode_getfd - creates a new file instance by hooking it up to an
  *                    anonymous inode, and a dentry that describe the "class"
  *                    of the file
  *
@@ -66,7 +66,7 @@ static struct dentry_operations anon_inodefs_dentry_operations = {
  *
  * Creates a new file by hooking it on a single inode. This is useful for files
  * that do not need to have a full-fledged inode in order to operate correctly.
- * All the files created with anon_inode_getfd() will share a single inode, by
+ * All the files created with anon_inode_getfd() will share a single inode,
  * hence saving memory and avoiding code duplication for the file/inode/dentry
  * setup.
  */
@@ -141,9 +141,9 @@ err_put_filp:
 }
 
 /*
- * A single inode exist for all anon_inode files. Contrary to pipes,
- * anon_inode inodes has no per-instance data associated, so we can avoid
- * the allocation of multiple of them.
+ * A single inode exists for all anon_inode files. Contrary to pipes,
+ * anon_inode inodes have no associated per-instance data, so we need
+ * only allocate one of them.
  */
 static struct inode *anon_inode_mkinode(void)
 {
-- 
1.5.2.rc3

