Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYIIXmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYIIXmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYIIXlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:41:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:18758 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYIIXlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eZj2IS5zk1z0IB+Ef8CxsWfcMGSb+Rc593+lKBeJOZCMbyl7thAATgwqr52nzB+9jN
         lQieSKF+omGYzkDrRsznbZDpTI6QpLMvje7Y4urNvAG6ehxmA1u7B/Gj8pyLgXfABuiB
         58pzInt+JlWeAh6IZmy826sWesMUA19dkkBps=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/5] x86: centaur_64.c remove duplicated setting with CONSTANT_TSC
Date: Tue,  9 Sep 2008 16:40:39 -0700
Message-Id: <1221003639-15912-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1221003639-15912-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221003639-15912-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/centaur_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
index 0e5cf17..a1625f5 100644
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ b/arch/x86/kernel/cpu/centaur_64.c
@@ -20,7 +20,6 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 
 	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-- 
1.5.4.5

