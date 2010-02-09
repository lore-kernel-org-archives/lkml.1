Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0BIEKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 23:10:48 -0500
Received: from ozlabs.org ([203.10.76.45]:37379 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab0BIEKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 23:10:46 -0500
Date: Tue, 9 Feb 2010 15:07:40 +1100
From: Anton Blanchard <anton@samba.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove reference to kthread_create_on_cpu
Message-ID: <20100209040740.GB3702@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kthread_create_on_cpu doesn't exist so update a comment in kthread.c to
reflect this.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/kernel/kthread.c
===================================================================
--- linux.trees.git.orig/kernel/kthread.c	2010-01-12 12:26:56.000000000 +1100
+++ linux.trees.git/kernel/kthread.c	2010-02-09 15:05:59.000000000 +1100
@@ -101,7 +101,7 @@ static void create_kthread(struct kthrea
  *
  * Description: This helper function creates and names a kernel
  * thread.  The thread will be stopped: use wake_up_process() to start
- * it.  See also kthread_run(), kthread_create_on_cpu().
+ * it.  See also kthread_run().
  *
  * When woken, the thread will run @threadfn() with @data as its
  * argument. @threadfn() can either call do_exit() directly if it is a
