Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXCLTTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXCLTTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXCLTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:19:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33758 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbXCLTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:19:30 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Mon, 12 Mar 2007 12:19:27 -0700
Subject: [patch 3/9] signalfd/timerfd v4 - signalfd wire up i386 arch ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.5142.1173727169.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wire the signalfd system call to the i386 architecture.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.20.ep2.orig/arch/i386/kernel/syscall_table.S	2007-03-11 14:28:28.000000000 -0700
+++ linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S	2007-03-11 14:28:44.000000000 -0700
@@ -319,3 +319,4 @@
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_signalfd		/* 320 */
Index: linux-2.6.20.ep2/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-i386/unistd.h	2007-03-11 14:28:28.000000000 -0700
+++ linux-2.6.20.ep2/include/asm-i386/unistd.h	2007-03-11 14:28:44.000000000 -0700
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_signalfd		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR

