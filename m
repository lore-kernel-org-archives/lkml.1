Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZELUNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZELUNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZELUM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:12:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:33229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZELUM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:12:56 -0400
Date: Tue, 12 May 2009 20:12:29 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.00.0905121431020.13338@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905121431020.13338@gandalf.stny.rr.com>
Subject: [tip:irq/urgent] genirq: fix comment to say IRQ_WAKE_THREAD
Message-ID: <tip-39a2eddb9b62959dc55c6978b5eaeb3dd57c5ff2@git.kernel.org>
Git-Commit-ID: 39a2eddb9b62959dc55c6978b5eaeb3dd57c5ff2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 20:12:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39a2eddb9b62959dc55c6978b5eaeb3dd57c5ff2
Gitweb:     http://git.kernel.org/tip/39a2eddb9b62959dc55c6978b5eaeb3dd57c5ff2
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 12 May 2009 14:35:54 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 May 2009 22:11:29 +0200

genirq: fix comment to say IRQ_WAKE_THREAD

Trying to implement a driver to use threaded irqs, I was confused when the 
return value to use that was described in the comment above 
request_threaded_irq was not defined.

Turns out that the enum is IRQ_WAKE_THREAD where as the comment said 
IRQ_THREAD_WAKE.

[Impact: do not confuse developers with wrong comments ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <alpine.DEB.2.00.0905121431020.13338@gandalf.stny.rr.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2734eca..eb47f8b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL(free_irq);
  *	still called in hard interrupt context and has to check
  *	whether the interrupt originates from the device. If yes it
  *	needs to disable the interrupt on the device and return
- *	IRQ_THREAD_WAKE which will wake up the handler thread and run
+ *	IRQ_WAKE_THREAD which will wake up the handler thread and run
  *	@thread_fn. This split handler design is necessary to support
  *	shared interrupts.
  *
