Return-Path: <linux-kernel-owner+w=401wt.eu-S1030517AbXCGO3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517AbXCGO3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXCGO3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:29:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030475AbXCGO3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:29:09 -0500
Subject: [GFS2] Remove unused variable [9/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:32:15 +0000
Message-Id: <1173277935.11001.770.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 04b159b132c0d8e92dae8c72f134fd5b13b43deb Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 1 Mar 2007 11:14:44 +0000
Subject: [PATCH] [GFS2] Remove unused variable

Remove an unused variable.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 12c80fd..0b2b545 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -416,7 +416,6 @@ struct gfs2_tune {
 	unsigned int gt_stall_secs; /* Detects trouble! */
 	unsigned int gt_complain_secs;
 	unsigned int gt_reclaim_limit; /* Max num of glocks in reclaim list */
-	unsigned int gt_entries_per_readdir;
 	unsigned int gt_statfs_quantum;
 	unsigned int gt_statfs_slow;
 };
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 70f424f..4fdda97 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -76,7 +76,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_stall_secs = 600;
 	gt->gt_complain_secs = 10;
 	gt->gt_reclaim_limit = 5000;
-	gt->gt_entries_per_readdir = 32;
 	gt->gt_statfs_quantum = 30;
 	gt->gt_statfs_slow = 0;
 }
-- 
1.4.4.2



