Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbYAUKGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbYAUKGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbYAUKCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbYAUKCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:10 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/58] [GFS2] Remove unused variables
Date: Mon, 21 Jan 2008 09:21:30 +0000
Message-Id: <1200907362266-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073611695-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
Message-Id: <2b2ccd5cd38298d4b6ed1b07d09bac437e8e2742.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

These haven't been used for some time, remove them.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 82dfe9b..f7a50fe 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -412,9 +412,6 @@ struct gfs2_args {
 struct gfs2_tune {
 	spinlock_t gt_spin;
 
-	unsigned int gt_ilimit;
-	unsigned int gt_ilimit_tries;
-	unsigned int gt_ilimit_min;
 	unsigned int gt_demote_secs; /* Cache retention for unheld glock */
 	unsigned int gt_incore_log_blocks;
 	unsigned int gt_log_flush_secs;
@@ -434,7 +431,6 @@ struct gfs2_tune {
 	unsigned int gt_new_files_jdata;
 	unsigned int gt_new_files_directio;
 	unsigned int gt_max_readahead; /* Max bytes to read-ahead from disk */
-	unsigned int gt_lockdump_size;
 	unsigned int gt_stall_secs; /* Detects trouble! */
 	unsigned int gt_complain_secs;
 	unsigned int gt_reclaim_limit; /* Max num of glocks in reclaim list */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 5183dfb..26edb7f 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -51,9 +51,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 {
 	spin_lock_init(&gt->gt_spin);
 
-	gt->gt_ilimit = 100;
-	gt->gt_ilimit_tries = 3;
-	gt->gt_ilimit_min = 1;
 	gt->gt_demote_secs = 300;
 	gt->gt_incore_log_blocks = 1024;
 	gt->gt_log_flush_secs = 60;
@@ -71,7 +68,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_new_files_jdata = 0;
 	gt->gt_new_files_directio = 0;
 	gt->gt_max_readahead = 1 << 18;
-	gt->gt_lockdump_size = 131072;
 	gt->gt_stall_secs = 600;
 	gt->gt_complain_secs = 10;
 	gt->gt_reclaim_limit = 5000;
-- 
1.5.1.2

