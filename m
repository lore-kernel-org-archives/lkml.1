Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYAUKDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYAUKDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759251AbYAUKCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036AbYAUKB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:01:58 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/58] [GFS2] Remove unused field in struct gfs2_inode
Date: Mon, 21 Jan 2008 09:21:23 +0000
Message-Id: <12009073512300-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073492811-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
Message-Id: <987cf4ac1626fc46b738dc2e2aed6128fde709b9.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Removes a field that is not used.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 5662ff9..e53da7d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -274,7 +274,6 @@ struct gfs2_inode {
 
 	spinlock_t i_spin;
 	struct rw_semaphore i_rw_mutex;
-	unsigned long i_last_pfault;
 };
 
 /*
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 950f314..5e52421 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -487,7 +487,6 @@ static struct inode *gfs2_alloc_inode(struct super_block *sb)
 	if (ip) {
 		ip->i_flags = 0;
 		ip->i_gl = NULL;
-		ip->i_last_pfault = jiffies;
 	}
 	return &ip->i_inode;
 }
-- 
1.5.1.2

