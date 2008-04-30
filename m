Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbYD3PI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbYD3PI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762501AbYD3PGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:06:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:36439 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762176AbYD3PGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:24 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       reiserfs-devel@vger.kernel.org
Subject: [PATCH] reiserfs: Fix typos in messages and comments (journalled -> journaled)
Date: Wed, 30 Apr 2008 17:06:17 +0200
Message-Id: <12095679812717-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1209567981323-git-send-email-jack@suse.cz>
References: y
 <12095679813226-git-send-email-jack@suse.cz>
 <12095679812375-git-send-email-jack@suse.cz>
 <12095679812452-git-send-email-jack@suse.cz>
 <1209567981639-git-send-email-jack@suse.cz>
 <1209567981323-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: reiserfs-devel@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 072116a..118b059 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -182,7 +182,7 @@ static int finish_unfinished(struct super_block *s)
 			int ret = reiserfs_quota_on_mount(s, i);
 			if (ret < 0)
 				reiserfs_warning(s,
-						 "reiserfs: cannot turn on journalled quota: error %d",
+						 "reiserfs: cannot turn on journaled quota: error %d",
 						 ret);
 		}
 	}
@@ -994,7 +994,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 
 			if (sb_any_quota_enabled(s)) {
 				reiserfs_warning(s,
-						 "reiserfs_parse_options: cannot change journalled quota options when quota turned on.");
+						 "reiserfs_parse_options: cannot change journaled quota options when quota turned on.");
 				return 0;
 			}
 			if (*arg) {	/* Some filename specified? */
@@ -1039,7 +1039,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 #else
 		if (c == 'u' || c == 'g' || c == 'f') {
 			reiserfs_warning(s,
-					 "reiserfs_parse_options: journalled quota options not supported.");
+					 "reiserfs_parse_options: journaled quota options not supported.");
 			return 0;
 		}
 #endif
@@ -1050,7 +1050,7 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 	    && (REISERFS_SB(s)->s_qf_names[USRQUOTA]
 		|| REISERFS_SB(s)->s_qf_names[GRPQUOTA])) {
 		reiserfs_warning(s,
-				 "reiserfs_parse_options: journalled quota format not specified.");
+				 "reiserfs_parse_options: journaled quota format not specified.");
 		return 0;
 	}
 	/* This checking is not precise wrt the quota type but for our purposes it is sufficient */
@@ -1980,7 +1980,7 @@ static int reiserfs_release_dquot(struct dquot *dquot)
 
 static int reiserfs_mark_dquot_dirty(struct dquot *dquot)
 {
-	/* Are we journalling quotas? */
+	/* Are we journaling quotas? */
 	if (REISERFS_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
 	    REISERFS_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
-- 
1.5.2.4

