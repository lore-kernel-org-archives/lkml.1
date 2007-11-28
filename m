Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbXK1Ttk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbXK1Ttk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXK1Ttd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:49:33 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38314 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbXK1Ttc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:49:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Nov 2007 11:49:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] update sys_ni.c with the new timerfd syscalls
Message-ID: <Pine.LNX.4.64.0711281148120.14548@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update sys_ni.c with the new timerfd syscalls.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 kernel/sys_ni.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/kernel/sys_ni.c
===================================================================
--- linux-2.6.mod.orig/kernel/sys_ni.c	2007-11-28 11:44:48.000000000 -0800
+++ linux-2.6.mod/kernel/sys_ni.c	2007-11-28 11:46:01.000000000 -0800
@@ -153,7 +153,9 @@
 
 /* New file descriptors */
 cond_syscall(sys_signalfd);
-cond_syscall(sys_timerfd);
+cond_syscall(sys_timerfd_create);
+cond_syscall(sys_timerfd_settime);
+cond_syscall(sys_timerfd_gettime);
 cond_syscall(compat_sys_signalfd);
 cond_syscall(compat_sys_timerfd);
 cond_syscall(sys_eventfd);

