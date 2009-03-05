Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZCEKtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZCEKtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbZCEKtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:49:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:45238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZCEKs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:48:59 -0500
Date: Thu, 5 Mar 2009 10:48:25 GMT
From: David Rientjes <rientjes@google.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, rientjes@google.com,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
Subject: [tip:core/locking] lockdep: remove duplicate CONFIG_DEBUG_LOCKDEP definitions
Message-ID: <tip-03d78913f01e8f6599823f00357ed17b32747d3d@git.kernel.org>
Git-Commit-ID: 03d78913f01e8f6599823f00357ed17b32747d3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 10:48:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03d78913f01e8f6599823f00357ed17b32747d3d
Gitweb:     http://git.kernel.org/tip/03d78913f01e8f6599823f00357ed17b32747d3d
Author:     "David Rientjes" <rientjes@google.com>
AuthorDate: Thu, 5 Mar 2009 02:29:05 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 11:46:00 +0100

lockdep: remove duplicate CONFIG_DEBUG_LOCKDEP definitions

Impact: cleanup

The atomic debug modifiers are already defined in
kernel/lockdep_internals.h.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 02014f7..9a1e2bc 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -433,13 +433,6 @@ atomic_t nr_find_usage_forwards_checks;
 atomic_t nr_find_usage_forwards_recursions;
 atomic_t nr_find_usage_backwards_checks;
 atomic_t nr_find_usage_backwards_recursions;
-# define debug_atomic_inc(ptr)		atomic_inc(ptr)
-# define debug_atomic_dec(ptr)		atomic_dec(ptr)
-# define debug_atomic_read(ptr)		atomic_read(ptr)
-#else
-# define debug_atomic_inc(ptr)		do { } while (0)
-# define debug_atomic_dec(ptr)		do { } while (0)
-# define debug_atomic_read(ptr)		0
 #endif
 
 /*
