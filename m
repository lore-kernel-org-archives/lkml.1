Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbYDQJ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbYDQJ4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933373AbYDQJ0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933540AbYDQJ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:50 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       David Teigland <teigland@redhat.com>,
       Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 45/48] [GFS2] fs/gfs2/recovery.c: suppress warnings
Date: Thu, 17 Apr 2008 09:39:21 +0100
Message-Id: <12084216611008-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216593910-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
 <1208421645785-git-send-email-swhiteho@redhat.com>
 <1208421647805-git-send-email-swhiteho@redhat.com>
 <12084216494161-git-send-email-swhiteho@redhat.com>
 <12084216511207-git-send-email-swhiteho@redhat.com>
 <12084216533319-git-send-email-swhiteho@redhat.com>
 <12084216553542-git-send-email-swhiteho@redhat.com>
 <1208421657826-git-send-email-swhiteho@redhat.com>
 <12084216593910-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org <akpm@linux-foundation.org>

fs/gfs2/recovery.c: In function 'get_log_header':
fs/gfs2/recovery.c:152: warning: 'lh.lh_sequence' may be used uninitialized in this function
fs/gfs2/recovery.c:152: warning: 'lh.lh_flags' may be used uninitialized in this function
fs/gfs2/recovery.c:152: warning: 'lh.lh_tail' may be used uninitialized in this function
fs/gfs2/recovery.c:152: warning: 'lh.lh_blkno' may be used uninitialized in this function
fs/gfs2/recovery.c:152: warning: 'lh.lh_hash' may be used uninitialized in this function

Cc: David Teigland <teigland@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index b17d3b8..06dcdc0 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -149,7 +149,7 @@ static int get_log_header(struct gfs2_jdesc *jd, unsigned int blk,
 			  struct gfs2_log_header_host *head)
 {
 	struct buffer_head *bh;
-	struct gfs2_log_header_host lh;
+	struct gfs2_log_header_host uninitialized_var(lh);
 	const u32 nothing = 0;
 	u32 hash;
 	int error;
-- 
1.5.1.2

