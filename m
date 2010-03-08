Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0CHXLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:11:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60388 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0CHXLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=meMQVXfDyCFwNfBu/haAr+EptPlRlTrsALO4q0OAw+4xW0kbHCFXBtII5g9ACh/l6C
         UMbC7Tv76mnfD7W7YjAfuP201SwItfNbveftFj/ShNj5omTDHuc9+SBtuG/O6cNvn5Xq
         rx4xBC6dFB5BoD3fvTJXNiLzh7TkyeIdXWd1M=
From: Chihau Chau <chihau@gmail.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Security: key: keyring: fix some code style issues
Date: Mon,  8 Mar 2010 20:11:34 -0300
Message-Id: <1268089894-28691-1-git-send-email-chihau@gmail.com>
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
 security/keys/keyring.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index e814d21..840be66 100644
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
@@ -306,7 +306,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 	key_check(keyring);
 
 	/* top keyring must have search permission to begin the search */
-        err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
+	err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
 	if (err < 0) {
 		key_ref = ERR_PTR(err);
 		goto error;
@@ -775,8 +775,7 @@ int __key_link(struct key *keyring, struct key *key)
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

