Return-Path: <linux-kernel-owner+w=401wt.eu-S1161477AbXDSJ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161477AbXDSJ2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161474AbXDSJ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:28:32 -0400
Received: from mx12.go2.pl ([193.17.41.142]:40120 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161477AbXDSJ2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:28:31 -0400
Date: Thu, 19 Apr 2007 11:34:07 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] lockdep: lookup_chain_cache comment errata
Message-ID: <20070419093407.GA3258@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] lockdep: lookup_chain_cache comment errata

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-rc7-/kernel/lockdep.c 2.6.21-rc7/kernel/lockdep.c
--- 2.6.21-rc7-/kernel/lockdep.c	2007-04-18 10:14:06.000000000 +0200
+++ 2.6.21-rc7/kernel/lockdep.c	2007-04-19 11:25:40.000000000 +0200
@@ -1313,8 +1313,9 @@ out_unlock_set:
 
 /*
  * Look up a dependency chain. If the key is not present yet then
- * add it and return 0 - in this case the new dependency chain is
- * validated. If the key is already hashed, return 1.
+ * add it and return 1 - in this case the new dependency chain is
+ * validated. If the key is already hashed, return 0.
+ * (On return with 1 graph_lock is held.)
  */
 static inline int lookup_chain_cache(u64 chain_key, struct lock_class *class)
 {
