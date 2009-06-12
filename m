Return-Path: <linux-kernel-owner+w=401wt.eu-S1765706AbZFLNdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765706AbZFLNdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZFLN0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:09 -0400
Received: from ozlabs.org ([203.10.76.45]:54993 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762614AbZFLN0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:26:01 -0400
CC: linux-kernel@vger.kernel.org
To: Tony Luck <tony.luck@intel.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:05 +0930
Subject: [PATCH 17/17] cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: ia64
Message-Id: <20090612132600.32B54DDD1B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There were replaced by topology_core_cpumask and topology_thread_cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/ia64/include/asm/topology.h |    2 --
 1 file changed, 2 deletions(-)

diff -r b1d85f253cf2 arch/ia64/include/asm/topology.h
--- a/arch/ia64/include/asm/topology.h	Thu Nov 20 11:58:09 2008 +1030
+++ b/arch/ia64/include/asm/topology.h	Thu Nov 20 12:00:50 2008 +1030
@@ -110,8 +110,6 @@
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)	(cpu_data(cpu)->socket_id)
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
-#define topology_core_siblings(cpu)		(cpu_core_map[cpu])
-#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_cpumask(cpu)		(&cpu_core_map[cpu])
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 #define smt_capable() 				(smp_num_siblings > 1)

