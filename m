Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYJaXOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYJaXOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 19:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYJaXNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 19:13:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:57754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYJaXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 19:13:53 -0400
Subject: [PATCH] ftrace: trace sched.c
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810311122540.20404@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810311122540.20404@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 00:13:49 +0100
Message-Id: <1225494829.21456.19.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: ftrace: trace sched.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Oct 31 16:32:54 CET 2008

Its useful to see what happens in sched.c

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/Makefile |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -21,7 +21,6 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
 obj-$(CONFIG_FREEZER) += freezer.o


