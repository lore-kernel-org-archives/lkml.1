Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXEBFfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXEBFfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030843AbXEBFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:35:18 -0400
Received: from haxent.com ([65.99.219.155]:2214 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030686AbXEBFfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:35:01 -0400
Message-Id: <20070502053428.511191000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:55 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 20/22] pollfs: export the plaio system call
Content-Disposition: inline; filename=pollfs-aio-syscall.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export the new plaio syscall prototype. While there, make it "conditional".

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 include/linux/syscalls.h |    2 ++
 kernel/sys_ni.c          |    1 +
 2 files changed, 3 insertions(+)

Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
@@ -611,4 +611,6 @@ asmlinkage long sys_pltimer(void);
 
 asmlinkage long sys_plfutex(void);
 
+asmlinkage long sys_plaio(aio_context_t ctx);
+
 #endif
Index: linux-2.6/kernel/sys_ni.c
===================================================================
--- linux-2.6.orig/kernel/sys_ni.c
+++ linux-2.6/kernel/sys_ni.c
@@ -115,6 +115,7 @@ cond_syscall(compat_sys_sysctl);
 cond_syscall(sys_plsignal);
 cond_syscall(sys_pltimer);
 cond_syscall(sys_plfutex);
+cond_syscall(sys_plaio);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);

--
