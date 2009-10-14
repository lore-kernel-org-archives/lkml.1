Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbZJNSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbZJNSsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbZJNSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:48:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54636 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761345AbZJNSsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:48:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Oct 2009 20:47:32 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH resend] sysfs: mark a locally-only used function static
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: James Morris <jmorris@namei.org>, "Stephen D. Smalley" <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
In-Reply-To: <1255444964.11749.340.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <tkrat.7aacb9f187b9bcfe@s5r6.in-berlin.de>
References: <tkrat.974f8a5e166a4c9f@s5r6.in-berlin.de>
 <1255444964.11749.340.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: David P. Quigley <dpquigl@tycho.nsa.gov>
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
-=====-==--= =-=- -===-
http://arcgraph.de/sr/

