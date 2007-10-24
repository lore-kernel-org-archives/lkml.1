Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXJXQ1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXJXQ1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbXJXQXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33321 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757247AbXJXQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:58 -0400
Date: Wed, 24 Oct 2007 18:23:27 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mark Fasheh <mark.fasheh@oracle.com>, Joel Becker <joel.becker@oracle.com>,
       kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ocfs2_find_entry_el() static
Message-ID: <20071024162327.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2_find_entry_el() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d7cac5a6c6884a16fe6fac7b6116f4a41ad7f309 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6a2f143..63b28fd 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -208,9 +208,9 @@ out:
 	return NULL;
 }
 
-struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
-					struct inode *dir,
-					struct ocfs2_dir_entry **res_dir)
+static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
+					       struct inode *dir,
+					       struct ocfs2_dir_entry **res_dir)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];

