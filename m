Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXEBFgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXEBFgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXEBFf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:35:27 -0400
Received: from haxent.com ([65.99.219.155]:2202 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030664AbXEBFe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:56 -0400
Message-Id: <20070502053427.352183000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:50 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 15/22] pollfs: export the plfutex system call
Content-Disposition: inline; filename=pollfs-futex-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export the new plfutex syscall prototype. While there, make it "conditional".

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 include/linux/syscalls.h |    2 ++
 kernel/sys_ni.c          |    1 +
 2 files changed, 3 insertions(+)

Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
@@ -609,4 +609,6 @@ asmlinkage long sys_plsignal(const sigse
 
 asmlinkage long sys_pltimer(void);
 
+asmlinkage long sys_plfutex(void);
+
 #endif
Index: linux-2.6/kernel/sys_ni.c
===================================================================
--- linux-2.6.orig/kernel/sys_ni.c
+++ linux-2.6/kernel/sys_ni.c
@@ -114,6 +114,7 @@ cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
 cond_syscall(sys_plsignal);
 cond_syscall(sys_pltimer);
+cond_syscall(sys_plfutex);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);

--
