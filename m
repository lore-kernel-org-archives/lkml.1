Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZLXCSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZLXCSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 21:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZLXCSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 21:18:23 -0500
Received: from mga06.intel.com ([134.134.136.21]:53141 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751108AbZLXCSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 21:18:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,446,1257148800"; 
   d="scan'208";a="581748976"
From: Chen Gong <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH] delete deprecated definition in cpu_up
Date: Thu, 24 Dec 2009 10:20:35 +0800
Message-Id: <1261621235-10627-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.6.6.rc4.11.g129a5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

additional_cpus is only supported for IA64 now. X86_64 should not be
included.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 1c8ddd6..53fcffb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -338,7 +338,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
-#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
+#if defined(CONFIG_IA64)
 		printk(KERN_ERR "please check additional_cpus= boot "
 				"parameter\n");
 #endif
-- 
1.6.6.rc4.11.g129a5

