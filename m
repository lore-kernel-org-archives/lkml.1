Return-Path: <linux-kernel-owner+w=401wt.eu-S1945900AbXDCUVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945900AbXDCUVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422704AbXDCUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:21:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51292 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945900AbXDCUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:21:14 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 03 Apr 2007 13:21:11 -0700
Subject: [patch 1/5] new fds fixes for 2.6.21-rc5.mm4 - fix a build error on x86_64 when the new CONFIG_* are not set ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.27063.1175631671.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a build error on x86_64 that happens when the new CONFIG_* options
for the new fds are not set



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.mm4/kernel/sys_ni.c
===================================================================
--- linux-2.6.21-rc5.mm4.orig/kernel/sys_ni.c	2007-04-03 13:17:25.000000000 -0700
+++ linux-2.6.21-rc5.mm4/kernel/sys_ni.c	2007-04-03 13:17:30.000000000 -0700
@@ -146,3 +146,9 @@
 cond_syscall(sys_bdflush);
 cond_syscall(sys_ioprio_set);
 cond_syscall(sys_ioprio_get);
+
+/* New file descriptors */
+cond_syscall(sys_signalfd);
+cond_syscall(sys_timerfd);
+cond_syscall(sys_eventfd);
+

