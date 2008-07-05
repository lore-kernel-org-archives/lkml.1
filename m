Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYGERtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYGERtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYGERiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:11 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33087 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755933AbYGERgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 11/52] ext4: Remove unused variable from ext4_show_options
Date: Sat,  5 Jul 2008 13:35:37 -0400
Message-Id: <1215279378-30504-12-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-11-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb96f12..d9d12c1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -671,7 +671,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	unsigned long def_mount_opts;
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	journal_t *journal = sbi->s_journal;
 	struct ext4_super_block *es = sbi->s_es;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
-- 
1.5.6.rc3.1.g36b7.dirty

