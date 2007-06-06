Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbXFFWc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbXFFWc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936407AbXFFWaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:30:46 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1339 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936294AbXFFWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:30:43 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 06 Jun 2007 15:30:31 -0700
Subject: [patch 5/8] fdmap v2 - wire sys_nonseqfd to i386
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4625.1181169039.5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wire the new sys_nonseqfd system call to the i386 architecture.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.mod.orig/arch/i386/kernel/syscall_table.S	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/arch/i386/kernel/syscall_table.S	2007-06-06 12:48:38.000000000 -0700
@@ -323,3 +323,4 @@
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_nonseqfd
Index: linux-2.6.mod/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-i386/unistd.h	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/include/asm-i386/unistd.h	2007-06-06 12:48:38.000000000 -0700
@@ -329,10 +329,11 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_nonseqfd		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 324
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR

