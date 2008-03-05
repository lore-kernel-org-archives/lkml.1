Return-Path: <linux-kernel-owner+w=401wt.eu-S1764862AbYCEBUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764862AbYCEBUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934462AbYCEBRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:52775 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934409AbYCEBRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JhrVhNQ/hyOg6QxOP+inbTsIvI1vR1gfJUoB3GLZT7Kj/05PresCoGtt4q6/uITHLugS9/cTYdyvprHfMNtAAVJTssNi2BpQv2rG9m7jxlEbTlk3k3ROpzVCQLIZD2Con99NjXk6teQp4h4g8dLrw9PKrnzbydbz9f2OwAOZ5a8=
Subject: [PATCH 6/9] xfs: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: xfs <xfs-masters@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:19 -0800
Message-Id: <1204679839.5698.72.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/xfs/linux-2.6/xfs_cred.h  |    2 +-
 fs/xfs/linux-2.6/xfs_stats.h |    4 ++--
 fs/xfs/quota/xfs_qm_stats.h  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_cred.h b/fs/xfs/linux-2.6/xfs_cred.h
index e7f3da6..652721c 100644
--- a/fs/xfs/linux-2.6/xfs_cred.h
+++ b/fs/xfs/linux-2.6/xfs_cred.h
@@ -30,7 +30,7 @@ typedef struct cred {
 extern struct cred *sys_cred;
 
 /* this is a hack.. (assumes sys_cred is the only cred_t in the system) */
-static __inline int capable_cred(cred_t *cr, int cid)
+static inline int capable_cred(cred_t *cr, int cid)
 {
 	return (cr == sys_cred) ? 1 : capable(cid);
 }
diff --git a/fs/xfs/linux-2.6/xfs_stats.h b/fs/xfs/linux-2.6/xfs_stats.h
index 8ba7a2f..afd0b0d 100644
--- a/fs/xfs/linux-2.6/xfs_stats.h
+++ b/fs/xfs/linux-2.6/xfs_stats.h
@@ -144,8 +144,8 @@ extern void xfs_cleanup_procfs(void);
 # define XFS_STATS_DEC(count)
 # define XFS_STATS_ADD(count, inc)
 
-static __inline void xfs_init_procfs(void) { };
-static __inline void xfs_cleanup_procfs(void) { };
+static inline void xfs_init_procfs(void) { };
+static inline void xfs_cleanup_procfs(void) { };
 
 #endif	/* !CONFIG_PROC_FS */
 
diff --git a/fs/xfs/quota/xfs_qm_stats.h b/fs/xfs/quota/xfs_qm_stats.h
index a50ffab..5b964fc 100644
--- a/fs/xfs/quota/xfs_qm_stats.h
+++ b/fs/xfs/quota/xfs_qm_stats.h
@@ -45,8 +45,8 @@ extern void xfs_qm_cleanup_procfs(void);
 
 # define XQM_STATS_INC(count)	do { } while (0)
 
-static __inline void xfs_qm_init_procfs(void) { };
-static __inline void xfs_qm_cleanup_procfs(void) { };
+static inline void xfs_qm_init_procfs(void) { };
+static inline void xfs_qm_cleanup_procfs(void) { };
 
 #endif
 
-- 
1.5.4.3.500.g83a2c


