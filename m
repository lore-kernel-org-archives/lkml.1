Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYLVWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYLVWCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYLVVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:57 -0500
Received: from ns.suse.de ([195.135.220.2]:41706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbYLVVt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:56 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 38/56] ext3: Add default allocation routines for quota structures
Date: Mon, 22 Dec 2008 13:48:19 -0800
Message-Id: <1229982517-3455-39-git-send-email-mfasheh@suse.com>
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
 fs/ext3/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 250ec53..c22d014 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -713,7 +713,9 @@ static struct dquot_operations ext3_quota_operations = {
 	.acquire_dquot	= ext3_acquire_dquot,
 	.release_dquot	= ext3_release_dquot,
 	.mark_dirty	= ext3_mark_dquot_dirty,
-	.write_info	= ext3_write_info
+	.write_info	= ext3_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops ext3_qctl_operations = {
-- 
1.5.6

