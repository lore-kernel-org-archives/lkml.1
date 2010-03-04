Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab0CDF2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:28:12 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:37583 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0CDF2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UWhHuTKZyrvW87o3H1JYRe4YoG0Cw4JQLeEH883ACmq0T36ozQ0p7MY4muyDu2Moli
         rcpuP8aHlJaALIoUbk3UGAWOmWPOhCjpsb+RaC8qlNwwldYr+CDgN5f98mUH6Dp6Od8e
         0ij4dwqC022i5nif0E9GXdOo06337rD2HUbPg=
Date: Thu, 4 Mar 2010 21:26:23 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
       dhowells@redhat.com
Subject: [PATCH 1/2] Security: Fix some coding styles in security/keys/keyring.c
Message-ID: <20100304132623.GA3740@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some coding styles in security/keys/keyring.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/keys/keyring.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 8ec0274..d77a7ef 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -168,12 +168,10 @@ static void keyring_describe(const struct key *keyring, struct seq_file *m)
 {
 	struct keyring_list *klist;
 
-	if (keyring->description) {
+	if (keyring->description)
 		seq_puts(m, keyring->description);
-	}
-	else {
+	else
 		seq_puts(m, "[anon]");
-	}
 
 	rcu_read_lock();
 	klist = rcu_dereference(keyring->payload.subscriptions);
-- 
1.6.5.3

