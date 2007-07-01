Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbXGAHju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbXGAHju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXGAHhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:37:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36229 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbXGAHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:37:06 -0400
Subject: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:37:04 -0400
Message-Id: <1183275424.4010.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the 32-bit i_version in the generic inode to a 64-bit
i_version field.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: linux-2.6.21/include/linux/fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/fs.h
+++ linux-2.6.21/include/linux/fs.h
@@ -549,7 +549,7 @@ struct inode {
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
-	unsigned long		i_version;
+	u64			i_version;
 	loff_t			i_size;
 #ifdef __NEED_I_SIZE_ORDERED
 	seqcount_t		i_size_seqcount;


