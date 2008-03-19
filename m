Return-Path: <linux-kernel-owner+w=401wt.eu-S1162575AbYCSW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162575AbYCSW4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765960AbYCSVYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:09 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966320AbYCSVYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:08 -0400
Date: Wed, 19 Mar 2008 21:20:43 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals-fold-sig_ignored-into-handle_stop_signal-comment
Message-ID: <20080319182043.GA6390@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comments update for signals-fold-sig_ignored-into-handle_stop_signal.patch

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~DOC_2_PREPARE	2008-03-19 20:53:45.000000000 +0300
+++ 25/kernel/signal.c	2008-03-19 21:15:30.000000000 +0300
@@ -572,11 +572,14 @@ static int check_kill_permission(int sig
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
 
 /*
- * Handle magic process-wide effects of stop/continue signals.
- * Unlike the signal actions, these happen immediately at signal-generation
+ * Handle magic process-wide effects of stop/continue signals. Unlike
+ * the signal actions, these happen immediately at signal-generation
  * time regardless of blocking, ignoring, or handling.  This does the
  * actual continuing for SIGCONT, but not the actual stopping for stop
- * signals.  The process stop is done as a signal action for SIG_DFL.
+ * signals. The process stop is done as a signal action for SIG_DFL.
+ *
+ * Returns true if the signal should be actually delivered, otherwise
+ * it should be dropped.
  */
 static int prepare_signal(int sig, struct task_struct *p)
 {

