Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZHNL2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZHNL2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZHNL2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:28:39 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51309 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbZHNL0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:48 -0400
Message-Id: <20090814112619.611605266@de.ibm.com>
References: <20090814112517.982007860@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 13:25:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Vitaliy Gusev <vgusev@openvz.org>, Michael Holzheu <holzheu@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 30/34] hypfs: remove useless variable qname
Content-Disposition: inline; filename=129-hypfs-useless-variable.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Gusev <vgusev@openvz.org>

Local variable 'qname' in the function hypfs_create_file() really is not
used for any purpose.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
Cc: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/hypfs/inode.c |    4 ----
 1 file changed, 4 deletions(-)

Index: quilt-2.6/arch/s390/hypfs/inode.c
===================================================================
--- quilt-2.6.orig/arch/s390/hypfs/inode.c
+++ quilt-2.6/arch/s390/hypfs/inode.c
@@ -355,11 +355,7 @@ static struct dentry *hypfs_create_file(
 {
 	struct dentry *dentry;
 	struct inode *inode;
-	struct qstr qname;
 
-	qname.name = name;
-	qname.len = strlen(name);
-	qname.hash = full_name_hash(name, qname.len);
 	mutex_lock(&parent->d_inode->i_mutex);
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (IS_ERR(dentry)) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

