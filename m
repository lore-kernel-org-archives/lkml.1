Return-Path: <linux-kernel-owner+w=401wt.eu-S934313AbYDQJgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313AbYDQJgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933470AbYDQJZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932981AbYDQJZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:21 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/48] [GFS2] Fix debug inode printing
Date: Thu, 17 Apr 2008 09:38:40 +0100
Message-Id: <12084215763647-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215742081-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

I noticed that the latest change to i_height got rid of the
value from the inode dump.  This patch adds it back.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index ff66ab7..db5961a 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -1435,6 +1435,7 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	printk(KERN_INFO "  di_goal_data = %llu\n",
 	       (unsigned long long)di->di_goal_data);
 	printk(KERN_INFO "  di_flags = 0x%.8X\n", di->di_flags);
+	printk(KERN_INFO "  i_height = %u\n", ip->i_height);
 	printk(KERN_INFO "  di_depth = %u\n", di->di_depth);
 	printk(KERN_INFO "  di_entries = %u\n", di->di_entries);
 	printk(KERN_INFO "  di_eattr = %llu\n",
-- 
1.5.1.2

