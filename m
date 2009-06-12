Return-Path: <linux-kernel-owner+w=401wt.eu-S1765177AbZFLN2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765177AbZFLN2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762802AbZFLNZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:56 -0400
Received: from ozlabs.org ([203.10.76.45]:54982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762936AbZFLNZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:55 -0400
CC: linux-kernel@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 14/17] cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: sparc
Message-Id: <20090612132557.44F64DDD0C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There were replaced by topology_core_cpumask and topology_thread_cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/sparc/include/asm/topology_64.h |    2 --
 1 file changed, 2 deletions(-)

diff -r b1d85f253cf2 arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h	Thu Nov 20 11:58:09 2008 +1030
+++ b/arch/sparc/include/asm/topology_64.h	Thu Nov 20 12:00:50 2008 +1030
@@ -77,8 +77,6 @@
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
-#define topology_core_siblings(cpu)		(cpu_core_map[cpu])
-#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define mc_capable()				(sparc64_multi_core)

