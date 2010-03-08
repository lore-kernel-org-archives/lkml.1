Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0CHSOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:14:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35943 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab0CHSOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:14:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oyoEqgfRtkaGFTMWec4GfnIfxgeGVyHWSppY51/XS8jF5odDjTvgF0iehF0eAEQaM6
         efEMXRBuAMG2xQbujSCvDtHg0Bd10dzgHtkGY2LgZDc2yBjl0mDwMk2BcIqM/R3UhJkh
         KuiQzhpct5hs1eIHmjCTosX7GasXnsGZ6AdX0=
From: Chihau Chau <chihau@gmail.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Security: key: keyring: fix code style issues
Date: Mon,  8 Mar 2010 15:14:38 -0300
Message-Id: <1268072078-27293-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some code style issues like to include <linux/uaccess.h> instead
<asm/uaccess.h> and to remove some innecessary braces.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 security/keys/keyring.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index e814d21..5a44965 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -17,7 +17,7 @@
 #include <linux/seq_file.h>
 #include <linux/err.h>
 #include <keys/keyring-type.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "internal.h"
 
 /*
@@ -170,12 +170,10 @@ static void keyring_describe(const struct key *keyring, struct seq_file *m)
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
@@ -775,8 +773,7 @@ int __key_link(struct key *keyring, struct key *key)
 		smp_wmb();
 		klist->nkeys++;
 		smp_wmb();
-	}
-	else {
+	} else {
 		/* grow the key list */
 		max = 4;
 		if (klist)
-- 
1.5.6.3

