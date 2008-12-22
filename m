Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbYLVWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbYLVWDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYLVVuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:50:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:38692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166AbYLVVuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:50:00 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 40/56] ocfs2: fix indendation in ocfs2_dquot_drop_slow
Date: Mon, 22 Dec 2008 13:48:21 -0800
Message-Id: <1229982517-3455-41-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota_global.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b0eae79..4b38a2e 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -896,7 +896,7 @@ static int ocfs2_dquot_drop_slow(struct inode *inode)
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
-				goto out;
+		goto out;
 	}
 	dquot_drop(inode);
 	ocfs2_commit_trans(OCFS2_SB(sb), handle);
-- 
1.5.6

