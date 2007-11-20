Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbXKTBvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbXKTBvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbXKTBtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:03 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2048 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbXKTBs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:56 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 07/59] arch/sparc64: Add missing "space"
Date: Mon, 19 Nov 2007 17:47:59 -0800
Message-Id: <1195523331-15303-8-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-7-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
Message-Id: <2cb1c8daa0f34a5506b88cf5b350660896c8a45b.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sparc64/kernel/smp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 7cd8d94..894b506 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -236,8 +236,9 @@ void smp_synchronize_tick_client(void)
 		       t[i].rt, t[i].master, t[i].diff, t[i].lat);
 #endif
 
-	printk(KERN_INFO "CPU %d: synchronized TICK with master CPU (last diff %ld cycles,"
-	       "maxerr %lu cycles)\n", smp_processor_id(), delta, rt);
+	printk(KERN_INFO "CPU %d: synchronized TICK with master CPU "
+	       "(last diff %ld cycles, maxerr %lu cycles)\n",
+	       smp_processor_id(), delta, rt);
 }
 
 static void smp_start_sync_tick_client(int cpu);
-- 
1.5.3.5.652.gf192c

