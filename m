Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXCKXEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXCKXEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbXCKXEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:04:15 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:32843 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622AbXCKXEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:04:07 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 11 Mar 2007 16:04:00 -0700
Subject: [patch 7/9] signalfd/timerfd v3 - timerfd wire up i386 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.5031.1173654243.7>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the timerfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.20.ep2.orig/arch/i386/kernel/syscall_table.S	2007-03-11 14:28:44.000000000 -0700
+++ linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S	2007-03-11 14:33:53.000000000 -0700
@@ -320,3 +320,4 @@
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_signalfd		/* 320 */
+	.long sys_timerfd
Index: linux-2.6.20.ep2/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-i386/unistd.h	2007-03-11 14:28:44.000000000 -0700
+++ linux-2.6.20.ep2/include/asm-i386/unistd.h	2007-03-11 14:33:53.000000000 -0700
@@ -326,10 +326,11 @@
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
 #define __NR_signalfd		320
+#define __NR_timerfd		321
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 321
+#define NR_syscalls 322
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR

