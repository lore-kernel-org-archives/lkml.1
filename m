Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXDVEZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXDVEZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 00:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXDVEZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 00:25:10 -0400
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:38902 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbXDVEZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 00:25:09 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: ymf typo
Date: Sun, 22 Apr 2007 14:24:37 +1000
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>
References: <200704221340.02349.kernel@kolivas.org>
In-Reply-To: <200704221340.02349.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221424.37753.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Typo in comment, 1us not 1ms.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-22 14:22:14.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-22 14:22:34.000000000 +1000
@@ -3045,7 +3045,7 @@ update_cpu_clock(struct task_struct *p, 
 		/*
 		 * Called from context_switch there should be less than one
 		 * jiffy worth, and not negative/overflow. There should be
-		 * some time banked here so use a nominal 1ms.
+		 * some time banked here so use a nominal 1us.
 		 */
 		if (time_diff > JIFFIES_TO_NS(1) || time_diff < 1)
 			time_diff = 1000;

-- 
-ck
