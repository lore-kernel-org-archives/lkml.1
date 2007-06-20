Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbXFTKYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbXFTKYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbXFTKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:36153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161AbXFTKXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [3/10] x86_64: Fix eventd/timerfd syscalls
Message-Id: <20070620102331.B083414AEB@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


They had the same syscall number. 

Pointed out by Davide Libenzi

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/unistd.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/include/asm-x86_64/unistd.h
===================================================================
--- linux.orig/include/asm-x86_64/unistd.h
+++ linux/include/asm-x86_64/unistd.h
@@ -626,9 +626,9 @@ __SYSCALL(__NR_utimensat, sys_utimensat)
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd		282
 __SYSCALL(__NR_signalfd, sys_signalfd)
-#define __NR_timerfd		282
+#define __NR_timerfd		283
 __SYSCALL(__NR_timerfd, sys_timerfd)
-#define __NR_eventfd		283
+#define __NR_eventfd		284
 __SYSCALL(__NR_eventfd, sys_eventfd)
 
 #ifndef __NO_STUBS
