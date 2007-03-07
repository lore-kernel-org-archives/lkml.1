Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXCGBhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXCGBhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbXCGBhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:37:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42316 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbXCGBhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:37:19 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 17:37:17 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 2/4] signalfd v1 - wire i386 syscall ...
Message-ID: <Pine.LNX.4.64.0703061707210.3661@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch wire the signalfd system call the the i386 arch.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



arch/i386/kernel/syscall_table.S |    1 +
include/asm-i386/unistd.h        |    3 ++-
2 files changed, 3 insertions(+), 1 deletion(-)




Index: linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S
===================================================================
--- linux-2.6.20.ep2.orig/arch/i386/kernel/syscall_table.S	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/arch/i386/kernel/syscall_table.S	2007-03-06 11:12:48.000000000 -0800
@@ -319,3 +319,4 @@
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_signalfd		/* 320 */
Index: linux-2.6.20.ep2/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.20.ep2.orig/include/asm-i386/unistd.h	2007-03-06 11:09:00.000000000 -0800
+++ linux-2.6.20.ep2/include/asm-i386/unistd.h	2007-03-06 11:12:48.000000000 -0800
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
