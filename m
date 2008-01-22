Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYAVDE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYAVDE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYAVDDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:03:08 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64724 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbYAVDDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:03:06 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 20/49] ext4/super.c: fix #ifdef's (CONFIG_EXT4_* -> CONFIG_EXT4DEV_*)
Date: Mon, 21 Jan 2008 22:01:59 -0500
Message-Id: <1200970948-17903-21-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-20-git-send-email-tytso@mit.edu>
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
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

Based on a report by Robert P. J. Day.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
---
 fs/ext4/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0931831..1484a08 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -706,7 +706,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",debug");
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
-#ifdef CONFIG_EXT4_FS_XATTR
+#ifdef CONFIG_EXT4DEV_FS_XATTR
 	if (test_opt(sb, XATTR_USER))
 		seq_puts(seq, ",user_xattr");
 	if (!test_opt(sb, XATTR_USER) &&
@@ -714,7 +714,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",nouser_xattr");
 	}
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
+#ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	if (test_opt(sb, POSIX_ACL))
 		seq_puts(seq, ",acl");
 	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
-- 
1.5.4.rc3.31.g1271-dirty

