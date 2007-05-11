Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbXEKXDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbXEKXDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbXEKXD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:03:26 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:45132 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbXEKXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:03:26 -0400
Date: Sat, 12 May 2007 01:02:49 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [patch] compat signalfd and timerfd are cond syscalls.
Message-ID: <20070511230249.GD8644@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Add missing cond_syscall statements for compat_sys_signalfd
and compat_sys_timerfd.

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Index: linux-2.6/kernel/sys_ni.c
===================================================================
--- linux-2.6.orig/kernel/sys_ni.c
+++ linux-2.6/kernel/sys_ni.c
@@ -145,4 +145,6 @@ cond_syscall(sys_ioprio_get);
 /* New file descriptors */
 cond_syscall(sys_signalfd);
 cond_syscall(sys_timerfd);
+cond_syscall(compat_sys_signalfd);
+cond_syscall(compat_sys_timerfd);
 cond_syscall(sys_eventfd);
