Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYGKLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYGKLI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYGKLCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbYGKLCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:03 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Li Xiaodong <lixd@cn.fujitsu.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/18] [GFS2] Remove unused declaration
Date: Fri, 11 Jul 2008 11:11:19 +0100
Message-Id: <12157711203714-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1215771119431-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
 <12157711041157-git-send-email-swhiteho@redhat.com>
 <1215771106247-git-send-email-swhiteho@redhat.com>
 <12157711073280-git-send-email-swhiteho@redhat.com>
 <12157711093284-git-send-email-swhiteho@redhat.com>
 <12157711133727-git-send-email-swhiteho@redhat.com>
 <12157711153366-git-send-email-swhiteho@redhat.com>
 <12157711171692-git-send-email-swhiteho@redhat.com>
 <1215771119431-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xiaodong <lixd@cn.fujitsu.com>

The implementation of gfs2_inode_attr_in is removed.
So remove its declaration.

Signed-off-by: Li Xiaodong <lixd@cn.fujitsu.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 04e9fef..6074c25 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -72,7 +72,6 @@ static inline void gfs2_inum_out(const struct gfs2_inode *ip,
 }
 
 
-void gfs2_inode_attr_in(struct gfs2_inode *ip);
 void gfs2_set_iop(struct inode *inode);
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
 				u64 no_addr, u64 no_formal_ino,
-- 
1.5.1.2

