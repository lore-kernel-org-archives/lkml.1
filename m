Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbXHFODs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbXHFODs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXHFNzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828AbXHFNzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:19 -0400
Date: Mon, 6 Aug 2007 09:54:53 -0400
Message-Id: <200708061354.l76Dsr1O002336@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 16/25] OCFS2: call attr_kill_to_mode from ocfs2_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ocfs2/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c4034f6..d05d472 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -972,6 +972,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
 
+	attr_kill_to_mode(inode, attr);
+
 	if (attr->ia_valid & ATTR_MODE)
 		mlog(0, "mode change: %d\n", attr->ia_mode);
 	if (attr->ia_valid & ATTR_UID)
-- 
1.5.2.2

