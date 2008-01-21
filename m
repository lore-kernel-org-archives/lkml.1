Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbYAUKKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbYAUKKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759778AbYAUKCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759679AbYAUKCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:31 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
       "Fabio M. Di Nitto" <fabbione@ubuntu.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/58] [GFS2] tidy up error message
Date: Mon, 21 Jan 2008 09:21:42 +0000
Message-Id: <12009073823161-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073803732-git-send-email-swhiteho@redhat.com>
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
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
Message-Id: <edc7d54bfba582d1815ad00ffe9f7faff9d51ba0.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Print error with log_error() to be consistent with others.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index ab30102..f2efff4 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -68,8 +68,7 @@ static int make_args(struct gdlm_ls *ls, char *data_arg, int *nodir)
 	strncpy(data, data_arg, 255);
 
 	if (!strlen(data)) {
-		printk(KERN_ERR
-		       "DLM/GFS2/GFS ERROR: (u)mount helpers are not installed!\n");
+		log_error("no mount options, (u)mount helpers not installed");
 		return -EINVAL;
 	}
 
-- 
1.5.1.2

