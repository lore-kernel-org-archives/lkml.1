Return-Path: <linux-kernel-owner+w=401wt.eu-S1765830AbXHFN3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765830AbXHFN3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245AbXHFNT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:19:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765427AbXHFNSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:18:18 -0400
Message-Id: <200708061318.l76DIChP001736@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 24 Jul 2007 13:00:41 -0400
Subject: [PATCH 14/25] JFFS2: call attr_kill_to_mode from jffs2_do_setattr
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: jffs-dev@axis.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/jffs2/fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 1d3b7a9..5218f04 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -37,6 +37,7 @@ static int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	uint32_t alloclen;
 	int ret;
 	D1(printk(KERN_DEBUG "jffs2_setattr(): ino #%lu\n", inode->i_ino));
+	attr_kill_to_mode(inode, iattr);
 	ret = inode_change_ok(inode, iattr);
 	if (ret)
 		return ret;
-- 
1.5.2.2

