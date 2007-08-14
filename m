Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbXHNVs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbXHNVs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbXHNV0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:26:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45860 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758863AbXHNV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:26:37 -0400
Date: Tue, 14 Aug 2007 23:26:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Latchesar Ionkov <lucho@ionkov.net>,
       Eric Van Hensbergen <ericvh@gmail.com>, rminnich@sandia.gov
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 v9fs_fid_lookup_remove()
Message-ID: <20070814212624.GA18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused v9fs_fid_lookup_remove().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 29 Jul 2007

 fs/9p/fid.c |    2 ++
 fs/9p/fid.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm1/fs/9p/fid.h.old	2007-07-26 13:22:00.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/9p/fid.h	2007-07-26 13:22:07.000000000 +0200
@@ -28,6 +28,5 @@
 };
 
 struct p9_fid *v9fs_fid_lookup(struct dentry *dentry);
-struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry);
 struct p9_fid *v9fs_fid_clone(struct dentry *dentry);
 int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid);
--- linux-2.6.23-rc1-mm1/fs/9p/fid.c.old	2007-07-26 13:22:22.000000000 +0200
+++ linux-2.6.23-rc1-mm1/fs/9p/fid.c	2007-07-26 13:22:40.000000000 +0200
@@ -92,6 +92,7 @@
 	return fid;
 }
 
+#if 0
 struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry)
 {
 	struct p9_fid *fid;
@@ -107,6 +108,7 @@
 
 	return fid;
 }
+#endif  /*  0  */
 
 
 /**

