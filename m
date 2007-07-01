Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXGAUTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXGAUTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXGAUTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:19:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46799 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754159AbXGAUTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:19:00 -0400
Date: Sun, 1 Jul 2007 22:19:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/rtmutex-debug.c: cleanups
Message-ID: <20070701201920.GA10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global variable rt_trace_on static
- remove the unused global function deadlock_trace_off()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 4 Apr 2007

--- linux-2.6.21-rc5-mm3/kernel/rtmutex-debug.c.old	2007-04-03 01:29:12.000000000 +0200
+++ linux-2.6.21-rc5-mm3/kernel/rtmutex-debug.c	2007-04-03 01:29:59.000000000 +0200
@@ -88,12 +88,7 @@
  * into the tracing code when doing error printk or
  * executing a BUG():
  */
-int rt_trace_on = 1;
-
-void deadlock_trace_off(void)
-{
-	rt_trace_on = 0;
-}
+static int rt_trace_on = 1;
 
 static void printk_task(struct task_struct *p)
 {

