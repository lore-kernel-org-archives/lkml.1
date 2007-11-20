Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbXKTByw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbXKTByw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbXKTBtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:17 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2065 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbXKTBtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:02 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk
Subject: [PATCH 14/59] drivers/cpufreq: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:06 -0800
Message-Id: <1195523331-15303-15-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-14-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
Message-Id: <f6014cdba9a3d017d1dcd0623a5da61777c919bb.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cpufreq/cpufreq.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5e626b1..5d5f52f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -287,7 +287,7 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 	if (!l_p_j_ref_freq) {
 		l_p_j_ref = loops_per_jiffy;
 		l_p_j_ref_freq = ci->old;
-		dprintk("saving %lu as reference value for loops_per_jiffy;"
+		dprintk("saving %lu as reference value for loops_per_jiffy; "
 			"freq is %u kHz\n", l_p_j_ref, l_p_j_ref_freq);
 	}
 	if ((val == CPUFREQ_PRECHANGE  && ci->old < ci->new) ||
@@ -295,7 +295,7 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
 		loops_per_jiffy = cpufreq_scale(l_p_j_ref, l_p_j_ref_freq,
 								ci->new);
-		dprintk("scaling loops_per_jiffy to %lu"
+		dprintk("scaling loops_per_jiffy to %lu "
 			"for frequency %u kHz\n", loops_per_jiffy, ci->new);
 	}
 }
@@ -1311,7 +1311,7 @@ static int cpufreq_resume(struct sys_device * sysdev)
 			struct cpufreq_freqs freqs;
 
 			if (!(cpufreq_driver->flags & CPUFREQ_PM_NO_WARN))
-				dprintk("Warning: CPU frequency"
+				dprintk("Warning: CPU frequency "
 				       "is %u, cpufreq assumed %u kHz.\n",
 				       cur_freq, cpu_policy->cur);
 
-- 
1.5.3.5.652.gf192c

