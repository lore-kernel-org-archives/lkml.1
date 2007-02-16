Return-Path: <linux-kernel-owner+w=401wt.eu-S1946308AbXBPXk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946308AbXBPXk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946309AbXBPXjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:33 -0500
Received: from ns1.suse.de ([195.135.220.2]:39558 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946308AbXBPXjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/10] debugfs: Remove misleading comments.
Date: Fri, 16 Feb 2007 15:37:33 -0800
Message-Id: <1171669076436-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <1171669073246-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de> <11716690633694-git-send-email-gregkh@suse.de> <11716690662679-git-send-email-gregkh@suse.de> <11716690692008-git-send-email-gregkh@suse.de> <1171669073246-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Just mention which error will be returned if debugfs is disabled. Callers
should be able to figure out themselves what they need to check.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 9c51a9f..7b324cf 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -212,9 +212,7 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
  * you are responsible here.)  If an error occurs, %NULL will be returned.
  *
  * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * returned.
  */
 struct dentry *debugfs_create_file(const char *name, mode_t mode,
 				   struct dentry *parent, void *data,
@@ -264,9 +262,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_file);
  * you are responsible here.)  If an error occurs, %NULL will be returned.
  *
  * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * returned.
  */
 struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 {
@@ -297,9 +293,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_dir);
  * returned.
  *
  * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * returned.
  */
 struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *target)
-- 
1.5.0

