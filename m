Return-Path: <linux-kernel-owner+w=401wt.eu-S934218AbZLKWbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218AbZLKWbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762762AbZLKWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:16 -0500
Received: from kroah.org ([198.145.64.141]:60990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762334AbZLKWYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/27] sysfs: mark a locally-only used function static
Date: Fri, 11 Dec 2009 14:24:24 -0800
Message-Id: <1260570289-6997-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: David P. Quigley <dpquigl@tycho.nsa.gov>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
1.6.5.5

