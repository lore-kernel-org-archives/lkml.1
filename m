Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZJKBDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZJKBDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 21:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZJKBDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 21:03:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46162 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZJKBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 21:03:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 11 Oct 2009 03:02:46 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] sysfs: mark a locally-only used function static
To: James Morris <jmorris@namei.org>
cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Stephen D. Smalley" <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Message-ID: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e28cecf..e144351 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -46,7 +46,7 @@ int __init sysfs_inode_init(void)
 	return bdi_init(&sysfs_backing_dev_info);
 }
 
-struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
+static struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
 {
 	struct sysfs_inode_attrs *attrs;
 	struct iattr *iattrs;
@@ -64,6 +64,7 @@ struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
 
 	return attrs;
 }
+
 int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 {
 	struct inode * inode = dentry->d_inode;

-- 
Stefan Richter
-=====-==--= =-=- -=-==
http://arcgraph.de/sr/

