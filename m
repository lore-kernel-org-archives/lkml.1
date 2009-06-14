Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZFNHKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZFNHKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZFNHKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:10:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49700 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZFNHKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:10:16 -0400
Date: Sun, 14 Jun 2009 07:09:46 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <4A3467E6.6010907@oracle.com>
References: <4A3467E6.6010907@oracle.com>
Subject: [tip:x86/urgent] x86: atomic_32.h: Fix kernel-doc warnings
Message-ID: <tip-46e443283891dbd45fba7fa037baab831f5d8f3f@git.kernel.org>
Git-Commit-ID: 46e443283891dbd45fba7fa037baab831f5d8f3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 14 Jun 2009 07:09:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46e443283891dbd45fba7fa037baab831f5d8f3f
Gitweb:     http://git.kernel.org/tip/46e443283891dbd45fba7fa037baab831f5d8f3f
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Sat, 13 Jun 2009 20:00:54 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Jun 2009 09:06:29 +0200

x86: atomic_32.h: Fix kernel-doc warnings

Fix kernel-doc warnings in atomic_32.h:

  Warning(arch/x86/include/asm/atomic_32.h:265): No description found for parameter 'ptr'
  Warning(arch/x86/include/asm/atomic_32.h:265): Excess function parameter 'v' description in '__atomic64_read'
  Warning(arch/x86/include/asm/atomic_32.h:305): Excess function parameter 'old_val' description in 'atomic64_xchg'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <4A3467E6.6010907@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index aff9f1f..a6a4b35 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -257,7 +257,7 @@ typedef struct {
 
 /**
  * atomic64_read - read atomic64 variable
- * @v: pointer of type atomic64_t
+ * @ptr: pointer of type atomic64_t
  *
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
@@ -294,7 +294,6 @@ atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
  * atomic64_xchg - xchg atomic64 variable
  * @ptr:      pointer to type atomic64_t
  * @new_val:  value to assign
- * @old_val:  old value that was there
  *
  * Atomically xchgs the value of @ptr to @new_val and returns
  * the old value.
