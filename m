Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXKKGtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXKKGtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 01:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbXKKGs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 01:48:58 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32863 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756598AbXKKGs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 01:48:57 -0500
Date: Sun, 11 Nov 2007 07:48:34 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] sched_fair.c: make sched_nr_latency static
Message-ID: <20071111064834.GH21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sched_nr_latency can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
fc6c112552b2eb423a29c2b0d100e97db3a47c45 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d3c0307..ee00da2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -43,7 +43,7 @@ unsigned int sysctl_sched_min_granularity = 1000000ULL;
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
  */
-unsigned int sched_nr_latency = 20;
+static unsigned int sched_nr_latency = 20;
 
 /*
  * After fork, child runs first. (default) If set to 0 then

