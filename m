Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZLNAGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZLNAGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZLNAG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:06:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbZLMX63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:29 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, neilb@suse.de,
       Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       torvalds@linux-foundation.org
Subject: [PATCH 2/2] Constify struct nlmsvc_binding for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:18 +0100
Message-Id: <d331cf697634fc8659dd7d5ab54ff701f1503490.1260663002.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663002.git.re.emese@gmail.com>
References: <cover.1260663002.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/lockd/bind.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/lockd/bind.h b/include/linux/lockd/bind.h
index fbc48f8..0886e57 100644
--- a/include/linux/lockd/bind.h
+++ b/include/linux/lockd/bind.h
@@ -23,13 +23,13 @@ struct svc_rqst;
  * This is the set of functions for lockd->nfsd communication
  */
 struct nlmsvc_binding {
-	__be32			(*fopen)(struct svc_rqst *,
+	__be32			(* const fopen)(struct svc_rqst *,
 						struct nfs_fh *,
 						struct file **);
-	void			(*fclose)(struct file *);
+	void			(* const fclose)(struct file *);
 };
 
-extern struct nlmsvc_binding *	nlmsvc_ops;
+extern const struct nlmsvc_binding *	nlmsvc_ops;
 
 /*
  * Similar to nfs_client_initdata, but without the NFS-specific
-- 
1.6.5.3

