Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZKWXUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZKWXUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbZKWXUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:20:35 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:42447 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757404AbZKWXUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:20:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4JAAqiCkuuWOh5/2dsb2JhbACBTZtFugeEPAQ
Date: Mon, 23 Nov 2009 18:20:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] h8300 thread flags cleanup
Message-ID: <20091123232032.GB9551@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:18:17 up 97 days, 10:07,  4 users,  load average: 0.57, 0.46,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-rc introduces incoherent coding style in thread_info.h. Make sure
the same style is used everywhere. Using style found in x86.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/include/asm/thread_info.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/arch/h8300/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/include/asm/thread_info.h	2009-11-22 20:42:35.000000000 -0500
+++ linux-2.6-lttng/arch/h8300/include/asm/thread_info.h	2009-11-22 20:42:53.000000000 -0500
@@ -93,13 +93,13 @@ static inline struct thread_info *curren
 #define TIF_FREEZE		16	/* is freezing for suspend */
 
 /* as above, but as bit values */
-#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
-#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
-#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
-#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
