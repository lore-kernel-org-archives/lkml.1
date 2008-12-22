Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYLVWDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYLVWDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbYLVVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:41714 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbYLVVt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:58 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 39/56] ext4: Add default allocation routines for quota structures
Date: Mon, 22 Dec 2008 13:48:20 -0800
Message-Id: <1229982517-3455-40-git-send-email-mfasheh@suse.com>
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
 fs/ext4/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9e5a717..e6a5d74 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -803,7 +803,9 @@ static struct dquot_operations ext4_quota_operations = {
 	.acquire_dquot	= ext4_acquire_dquot,
 	.release_dquot	= ext4_release_dquot,
 	.mark_dirty	= ext4_mark_dquot_dirty,
-	.write_info	= ext4_write_info
+	.write_info	= ext4_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops ext4_qctl_operations = {
-- 
1.5.6

