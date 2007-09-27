Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXI0OKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXI0OKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbXI0OJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:09:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbXI0OJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:09:44 -0400
Message-Id: <20070927141227.965678524@X40.localnet>
References: <20070927141200.820970144@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Thu, 27 Sep 2007 16:12:04 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@lst.de, agruen@suse.de, tiwai@suse.de
Subject: [patch 04/10] Move struct path into its own header
Content-Disposition: inline; filename=nameidata-path-1.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition of struct path into its own header file for further
patches.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 include/linux/namei.h |    6 +-----
 include/linux/path.h  |   12 ++++++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

Index: b/include/linux/namei.h
===================================================================
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -3,6 +3,7 @@
 
 #include <linux/dcache.h>
 #include <linux/linkage.h>
+#include <linux/path.h>
 
 struct vfsmount;
 
@@ -29,11 +30,6 @@ struct nameidata {
 	} intent;
 };
 
-struct path {
-	struct vfsmount *mnt;
-	struct dentry *dentry;
-};
-
 /*
  * Type of the last component on LOOKUP_PARENT
  */
Index: b/include/linux/path.h
===================================================================
--- /dev/null
+++ b/include/linux/path.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_PATH_H
+#define _LINUX_PATH_H
+
+struct dentry;
+struct vfsmount;
+
+struct path {
+	struct vfsmount *mnt;
+	struct dentry *dentry;
+};
+
+#endif  /* _LINUX_PATH_H */

-- 

