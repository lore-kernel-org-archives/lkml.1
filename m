Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYLVV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYLVV7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755874AbYLVVtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:41 -0500
Received: from ns.suse.de ([195.135.220.2]:41670 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbYLVVtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:40 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 30/56] ocfs2: Add missing initialization
Date: Mon, 22 Dec 2008 13:48:11 -0800
Message-Id: <1229982517-3455-31-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Add missing variable initialization to ocfs2_dquot_drop_slow().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_global.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index d2a5bfa..7f561e4 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -873,7 +873,7 @@ out:
 
 static int ocfs2_dquot_drop_slow(struct inode *inode)
 {
-	int status;
+	int status = 0;
 	int cnt;
 	int got_lock[MAXQUOTAS] = {0, 0};
 	handle_t *handle;
-- 
1.5.6

