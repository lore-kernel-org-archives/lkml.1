Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYHMInY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYHMInY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYHMIjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:33 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31884 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYHMIj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:29 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: fix typos in comments
Date: Wed, 13 Aug 2008 13:17:44 +0300
Message-Id: <1218622675-28853-16-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0675 (UTC) FILETIME=[0A7C2CB0:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/journal.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 0bcee7d..25de6fd 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -822,7 +822,7 @@ out_free:
 }
 
 /**
- * ubifs_jnl_write_inode - delete an inode.
+ * ubifs_jnl_delete_inode - delete an inode.
  * @c: UBIFS file-system description object
  * @inode: inode to delete
  *
@@ -831,21 +831,21 @@ out_free:
  * journal.
  *
  * When regular file inodes are unlinked or a directory inode is removed, the
- * 'ubifs_jnl_update()' function write corresponding deletion inode and
+ * 'ubifs_jnl_update()' function writes a corresponding deletion inode and
  * direntry to the media, and adds the inode to orphans. After this, when the
  * last reference to this inode has been dropped, this function is called. In
  * general, it has to write one more deletion inode to the media, because if
  * a commit happened between 'ubifs_jnl_update()' and
  * 'ubifs_jnl_delete_inode()', the deletion inode is not in the journal
- * anymore, and in fact it might be not on the flash anymore, becouse it might
- * have been garbage-collected already. And for optimization reasond UBIFS does
+ * anymore, and in fact it might not be on the flash anymore, because it might
+ * have been garbage-collected already. And for optimization reasons UBIFS does
  * not read the orphan area if it has been unmounted cleanly, so it would have
  * no indication in the journal that there is a deleted inode which has to be
  * removed from TNC.
  *
  * However, if there was no commit between 'ubifs_jnl_update()' and
  * 'ubifs_jnl_delete_inode()', then there is no need to write the deletion
- * inode to the media for the second time. And this is quite typical case.
+ * inode to the media for the second time. And this is quite a typical case.
  *
  * This function returns zero in case of success and a negative error code in
  * case of failure.
-- 
1.5.4.1

