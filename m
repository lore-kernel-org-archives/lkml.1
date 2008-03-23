Return-Path: <linux-kernel-owner+w=401wt.eu-S1765601AbYCWIoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765601AbYCWIoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759158AbYCWIK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:57 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2315 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759951AbYCWIKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:52 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 131/148] include/asm-x86/topology.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:46 -0700
Message-Id: <1206259443-13210-132-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 5bc825b..46a8994 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -72,7 +72,7 @@ static inline int cpu_to_node(int cpu)
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 	if (x86_cpu_to_node_map_early_ptr) {
 		printk("KERN_NOTICE cpu_to_node(%d): usage too early!\n",
-			(int)cpu);
+		       (int)cpu);
 		dump_stack();
 		return ((int *)x86_cpu_to_node_map_early_ptr)[cpu];
 	}
-- 
1.5.4.rc2

