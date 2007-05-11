Return-Path: <linux-kernel-owner+w=401wt.eu-S966122AbXEKXEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966122AbXEKXEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbXEKXEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:04:42 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:45158 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbXEKXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:04:41 -0400
Date: Sat, 12 May 2007 01:04:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch] x86_64: use signalfd and timerfd compat syscalls
Message-ID: <20070511230406.GE8644@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Looks like these two are wired up in a wrong way.

Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/x86_64/ia32/ia32entry.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ia32entry.S
+++ linux-2.6/arch/x86_64/ia32/ia32entry.S
@@ -716,7 +716,7 @@ ia32_sys_call_table:
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
-	.quad sys_signalfd
-	.quad sys_timerfd
+	.quad compat_sys_signalfd
+	.quad compat_sys_timerfd
 	.quad sys_eventfd
-ia32_syscall_end:		
+ia32_syscall_end:
