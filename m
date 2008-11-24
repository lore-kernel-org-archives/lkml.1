Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYKXVOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYKXVOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYKXVOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:14:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:19700 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYKXVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:14:45 -0500
Message-ID: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com>
Date: Mon, 24 Nov 2008 22:14:43 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "David Howells" <dhowells@redhat.com>, "James Morris" <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] CRED: fix sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warnings

Fix the following sparse warnings:

  security/security.c:228:2: warning: returning void-valued expression
  security/security.c:233:2: warning: returning void-valued expression
  security/security.c:616:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 security/security.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/security.c b/security/security.c
index 038ef04..f0d96a6 100644
--- a/security/security.c
+++ b/security/security.c
@@ -225,12 +225,12 @@ int security_bprm_check(struct linux_binprm *bprm)

 void security_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_committing_creds(bprm);
+	security_ops->bprm_committing_creds(bprm);
 }

 void security_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_committed_creds(bprm);
+	security_ops->bprm_committed_creds(bprm);
 }

 int security_bprm_secureexec(struct linux_binprm *bprm)
@@ -613,7 +613,7 @@ int security_prepare_creds(struct cred *new, const
struct cred *old, gfp_t gfp)

 void security_commit_creds(struct cred *new, const struct cred *old)
 {
-	return security_ops->cred_commit(new, old);
+	security_ops->cred_commit(new, old);
 }

 int security_kernel_act_as(struct cred *new, u32 secid)
-- 
1.5.6.3
