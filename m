Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351Ab0AKUVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0AKUVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223Ab0AKUVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:21:40 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45744 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab0AKUVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=N5tf05ZuZ8hloGufYu+/EvzsnVjRrznrR5kC20wMnH+Fqahg9AjhuZswycSnSj9GUK
         cB6fFvnUp1JDZb+XZl2BIlKZYoTTnjBrXRwsPySI0x5H0D71PJIOW4gbM8zyQ/LacM29
         QKq5Lk02zF1MrgXQU/mP2VVKZ04jo/UBj89fM=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/2] spinlock: Fix some indentation problems in spinlock.h
Date: Mon, 11 Jan 2010 21:21:07 +0100
Message-Id: <1263241267-25204-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263241267-25204-2-git-send-email-jkacur@redhat.com>
References: <1263241267-25204-1-git-send-email-jkacur@redhat.com>
 <1263241267-25204-2-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/spinlock.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 8608821..d2df17b 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -63,14 +63,14 @@
 #define LOCK_SECTION_NAME ".text.lock."KBUILD_BASENAME
 
 #define LOCK_SECTION_START(extra)               \
-        ".subsection 1\n\t"                     \
-        extra                                   \
-        ".ifndef " LOCK_SECTION_NAME "\n\t"     \
-        LOCK_SECTION_NAME ":\n\t"               \
-        ".endif\n"
+	".subsection 1\n\t"                     \
+	extra                                   \
+	".ifndef " LOCK_SECTION_NAME "\n\t"     \
+	LOCK_SECTION_NAME ":\n\t"               \
+	".endif\n"
 
 #define LOCK_SECTION_END                        \
-        ".previous\n\t"
+	".previous\n\t"
 
 #define __lockfunc __attribute__((section(".spinlock.text")))
 
@@ -170,10 +170,10 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock)
 	_raw_spin_lock_nested(lock, subclass)
 
 # define raw_spin_lock_nest_lock(lock, nest_lock)			\
-	 do {								\
-		 typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
-		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
-	 } while (0)
+	do {								\
+		typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
+		_raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
+	} while (0)
 #else
 # define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
 # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
-- 
1.6.5.2

