Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbYBMVnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbYBMVnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763914AbYBMVaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:52 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47524 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763866AbYBMVav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:51 -0500
Date: Wed, 13 Feb 2008 23:30:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make smackfs.c:smk_cipso_doi() static
Message-ID: <20080213213035.GI3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smk_cipso_doi() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

BTW: -ENOMAINTAINERSENTRY

299c2883384303ca7730df8fa4baae9194bd5d13 diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 15aa37f..13462ff 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -336,7 +336,7 @@ static const struct file_operations smk_load_ops = {
 /**
  * smk_cipso_doi - initialize the CIPSO domain
  */
-void smk_cipso_doi(void)
+static void smk_cipso_doi(void)
 {
 	int rc;
 	struct cipso_v4_doi *doip;

