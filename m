Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZJGKcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZJGKcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZJGKcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:32:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbZJGKcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:32:51 -0400
Date: Wed, 7 Oct 2009 10:31:41 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20091007001358.GE16073@kryten>
References: <20091007001358.GE16073@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Fix typo in FUTEX_WAIT/WAKE_BITSET_PRIVATE definitions
Message-ID: <tip-f8d1e548931cfa5ea9a082e020c2a47d27e5d793@git.kernel.org>
Git-Commit-ID: f8d1e548931cfa5ea9a082e020c2a47d27e5d793
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 10:31:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8d1e548931cfa5ea9a082e020c2a47d27e5d793
Gitweb:     http://git.kernel.org/tip/f8d1e548931cfa5ea9a082e020c2a47d27e5d793
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 7 Oct 2009 11:13:58 +1100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 7 Oct 2009 12:26:55 +0200

futex: Fix typo in FUTEX_WAIT/WAKE_BITSET_PRIVATE definitions

Looks like a typo, FUTEX_WAKE_BITS should be FUTEX_WAIT_BITSET.

Signed-off-by: Anton Blanchard <anton@samba.org>
LKML-Reference: <20091007001358.GE16073@kryten>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/futex.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 34956c8..78b92ec 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -38,8 +38,8 @@ union ktime;
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
