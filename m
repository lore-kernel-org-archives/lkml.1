Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0CITEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:04:05 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36532 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab0CITD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:03:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m4eTgVm/GiQtYLD+fGetU5dzfiwd8rKSjVfAtMFKdORii4nfEgni79JLgNUb7RLH93
         +7KFz8eveuRr9h0BtfT90Kwz1HiQgXs9rdcAf0kxgPZfKUZH8dslJnLoZ0u1fBFX3RHz
         YC3HO849befGfpHMFooVZyDD3KVvDRgRrJFVU=
From: Chihau Chau <chihau@gmail.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Security: key: keyring: fix code style issues
Date: Tue,  9 Mar 2010 16:03:48 -0300
Message-Id: <1268161428-32317-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes to include <linux/uaccess.h> instead <asm/uaccess.h> and some
code style issues like to put a else sentence below close brace '}' and
to replace a tab instead of some space characters.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 security/keys/keyring.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index e814d21..d8b5d5e 100644
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
@@ -172,8 +172,7 @@ static void keyring_describe(const struct key *keyring, struct seq_file *m)
 
 	if (keyring->description) {
 		seq_puts(m, keyring->description);
-	}
-	else {
+	} else {
 		seq_puts(m, "[anon]");
 	}
 
@@ -306,7 +305,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 	key_check(keyring);
 
 	/* top keyring must have search permission to begin the search */
-        err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
+	err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
 	if (err < 0) {
 		key_ref = ERR_PTR(err);
 		goto error;
@@ -775,8 +774,7 @@ int __key_link(struct key *keyring, struct key *key)
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

