Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYLVWCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYLVWCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYLVVtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYLVVty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:54 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 37/56] reiserfs: Add default allocation routines for quota structures
Date: Mon, 22 Dec 2008 13:48:18 -0800
Message-Id: <1229982517-3455-38-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/reiserfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index a9b393a..c55651f 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -649,6 +649,8 @@ static struct dquot_operations reiserfs_quota_operations = {
 	.release_dquot = reiserfs_release_dquot,
 	.mark_dirty = reiserfs_mark_dquot_dirty,
 	.write_info = reiserfs_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops reiserfs_qctl_operations = {
-- 
1.5.6

