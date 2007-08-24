Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbXHXIYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbXHXIYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbXHXIYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:24:18 -0400
Received: from alnrmhc16.comcast.net ([206.18.177.56]:52800 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbXHXIYQ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:24:16 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 04:24:16 EDT
Subject: [PATCH RT] - trivial branch in scheduler.
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: RT Users List <linux-rt-users@vger.kernel.org>,
       LKML <Linux-kernel@vger.kernel.org>,
       Peter Williams <pwil3058@bigpond.net.au>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Fri, 24 Aug 2007 01:19:08 -0700
Message-Id: <1187943548.16573.10.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

the trivial code is in various RT patches as well as in 2.6.23-rc git's
scheduler.

Thanks

Sven

Remove trivial conditional branch in Linux RT CFS 
scheduler's can_migrate_task function.

signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>

Index: linux-2.6.22/kernel/sched.c
===================================================================
--- linux-2.6.22.orig/kernel/sched.c
+++ linux-2.6.22/kernel/sched.c
@@ -2603,12 +2603,6 @@ int can_migrate_task(struct task_struct 
 	if (task_running(rq, p))
 		return 0;
 
-	/*
-	 * Aggressive migration if too many balance attempts have failed:
-	 */
-	if (sd->nr_balance_failed > sd->cache_nice_tries)
-		return 1;
-
 	return 1;
 }
 

