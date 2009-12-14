Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZLMX66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZLMX66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZLMX6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35187 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbZLMX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:50 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, neilb@suse.de,
       Trond.Myklebust@netapp.com, ebiederm@xmission.com,
       torvalds@linux-foundation.org
Subject: [PATCH 1/2] Constify struct nlmsvc_binding for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:17 +0100
Message-Id: <9ed6c6b6f59d9b93907d0bc19d976d8587f6c7de.1260663002.git.re.emese@gmail.com>
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
 fs/lockd/svc.c  |    2 +-
 fs/nfsd/lockd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index e50cfa3..7d89e3e 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -43,7 +43,7 @@
 
 static struct svc_program	nlmsvc_program;
 
-struct nlmsvc_binding *		nlmsvc_ops;
+const struct nlmsvc_binding *	nlmsvc_ops;
 EXPORT_SYMBOL_GPL(nlmsvc_ops);
 
 static DEFINE_MUTEX(nlmsvc_mutex);
diff --git a/fs/nfsd/lockd.c b/fs/nfsd/lockd.c
index b2786a5..f717a27 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -67,7 +67,7 @@ nlm_fclose(struct file *filp)
 	fput(filp);
 }
 
-static struct nlmsvc_binding	nfsd_nlm_ops = {
+static const struct nlmsvc_binding	nfsd_nlm_ops = {
 	.fopen		= nlm_fopen,		/* open file for locking */
 	.fclose		= nlm_fclose,		/* close file */
 };
-- 
1.6.5.3

