Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbXKTCHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbXKTCHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbXKTBxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:53:55 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2200 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681AbXKTBxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:53:51 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Kurt Hackel <kurt.hackel@oracle.com>, Mark Fasheh <mark.fasheh@oracle.com>,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 47/59] fs/ocfs2: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:34 -0800
Message-Id: <1195523627-15389-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-4-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
 <1195523627-15389-2-git-send-email-joe@perches.com>
 <1195523627-15389-3-git-send-email-joe@perches.com>
 <1195523627-15389-4-git-send-email-joe@perches.com>
Message-Id: <82a29b02f6151dd2d9a34d071e24f0726b8466d0.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++--
 fs/ocfs2/inode.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 62e4a7d..a54d33d 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -908,7 +908,7 @@ lookup:
 		 * but they might own this lockres.  wait on them. */
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to"
+			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to "
 			     "recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
@@ -962,7 +962,7 @@ redo_request:
 		spin_lock(&dlm->spinlock);
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to"
+			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to "
 			     "recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 1d5e0cb..9e3e7df 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -863,7 +863,7 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 	status = ocfs2_try_open_lock(inode, 1);
 	if (status == -EAGAIN) {
 		status = 0;
-		mlog(0, "Skipping delete of %llu because it is in use on"
+		mlog(0, "Skipping delete of %llu because it is in use on "
 		     "other nodes\n", (unsigned long long)oi->ip_blkno);
 		goto bail;
 	}
-- 
1.5.3.5.652.gf192c

