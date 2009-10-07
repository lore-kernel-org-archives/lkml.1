Return-Path: <linux-kernel-owner+w=401wt.eu-S933758AbZJGASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbZJGASn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933716AbZJGASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:18:43 -0400
Received: from ozlabs.org ([203.10.76.45]:46353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711AbZJGASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:18:42 -0400
Date: Wed, 7 Oct 2009 11:13:58 +1100
From: Anton Blanchard <anton@samba.org>
To: tgxl@linutronix.de, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] futex: Fix typo in FUTEX_WAIT_BITSET_PRIVATE and
	FUTEX_WAKE_BITSET_PRIVATE definitions
Message-ID: <20091007001358.GE16073@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks like a typo, FUTEX_WAKE_BITS should be FUTEX_WAIT_BITSET.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/include/linux/futex.h
===================================================================
--- linux.trees.git.orig/include/linux/futex.h	2009-10-02 16:53:02.000000000 +1000
+++ linux.trees.git/include/linux/futex.h	2009-10-02 16:53:42.000000000 +1000
@@ -33,8 +33,8 @@
 #define FUTEX_LOCK_PI_PRIVATE	(FUTEX_LOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_UNLOCK_PI_PRIVATE	(FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
-#define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
-#define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITSET | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITSET | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
 #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
