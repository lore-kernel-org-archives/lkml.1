Return-Path: <linux-kernel-owner+w=401wt.eu-S1945919AbXBHWHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945919AbXBHWHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945917AbXBHWHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:07:38 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41271 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945919AbXBHWHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:07:37 -0500
X-Originating-Ip: 74.102.209.62
Date: Thu, 8 Feb 2007 17:06:12 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Message-ID: <Pine.LNX.4.64.0702081701530.4820@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Subject: [PATCH] Kconfig:  Remove DEBUG_RWSEMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove the final vestiges of the kernel config option DEBUG_RWSEMS,
since it has no value, at least at the moment.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  my apologies for pushing this so high up the food chain, but i want
to submit another patch that sits *right* next to this one in the
Kconfig.debug file so i either have to do it in two steps, or submit
those two changes as a single patch, and i don't like doing that.

  so if this can go in in short order, well, that would be just ducky.
if it can't, then just toss it and i'll move on to that second patch.


diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 5c26818..356a5ab 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -181,19 +181,11 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.

-config DEBUG_RWSEMS
-	bool "RW-sem debugging: basic checks"
-	depends on DEBUG_KERNEL
-	help
-	 This feature allows read-write semaphore semantics violations to
-	 be detected and reported.
-
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
-	select DEBUG_RWSEMS
 	select LOCKDEP
 	help
 	 This feature will check whether any held lock (spinlock, rwlock,
@@ -209,7 +201,6 @@ config PROVE_LOCKING
 	select LOCKDEP
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
-	select DEBUG_RWSEMS
 	select DEBUG_LOCK_ALLOC
 	default n
 	help

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
