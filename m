Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXGDALQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXGDALQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXGDALE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:11:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:37614 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751529AbXGDALD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:11:03 -0400
Date: Wed, 4 Jul 2007 02:14:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] Two trivial whitespace fixes in lockdep/spinlock code
Message-ID: <Pine.LNX.4.64.0707040213340.11634@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Two trivial whitespace fixes in lockdep/spinlock code

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1a5ff22..12ca5fd 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1222,7 +1222,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 	/*
 	 * Debug-check: all keys must be persistent!
- 	 */
+	 */
 	if (!static_obj(lock->key)) {
 		debug_locks_off();
 		printk("INFO: trying to register non-static key.\n");
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 2c6c2bf..5386d7e 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -28,7 +28,7 @@ int __lockfunc _spin_trylock(spinlock_t *lock)
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
-	
+
 	preempt_enable();
 	return 0;
 }
