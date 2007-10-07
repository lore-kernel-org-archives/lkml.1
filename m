Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbXJGVBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbXJGVBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbXJGVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:00:06 -0400
Received: from ns.suse.de ([195.135.220.2]:32813 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbXJGVAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:00:01 -0400
From: Andi Kleen <ak@suse.de>
References: <200710071059.126674000@suse.de>
In-Reply-To: <200710071059.126674000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] [6/6] scheduler: Remove bogus comment in sched_group_set_shares
Message-Id: <20071007205959.8BBD11474B@wotan.suse.de>
Date: Sun,  7 Oct 2007 22:59:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Function never returns -EINVAL.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched.c
+++ linux-2.6-sched-devel/kernel/sched.c
@@ -6814,8 +6814,6 @@ int sched_group_set_shares(struct task_g
 	if (tg->shares == shares)
 		return 0;
 
-	/* return -EINVAL if the new value is not sane */
-
 	tg->shares = shares;
 	for_each_possible_cpu(i)
 		set_se_shares(tg->se[i], shares);
