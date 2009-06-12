Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbZFLNbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbZFLNbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762815AbZFLN0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:03 -0400
Received: from ozlabs.org ([203.10.76.45]:54995 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762814AbZFLNZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:59 -0400
CC: linux-kernel@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:05 +0930
Subject: [PATCH 16/17] cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: powerpc
Message-Id: <20090612132601.45BD8DDD0C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There were replaced by topology_core_cpumask and topology_thread_cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/powerpc/include/asm/topology.h |    2 --
 1 file changed, 2 deletions(-)

diff -r b1d85f253cf2 arch/powerpc/include/asm/topology.h
--- a/arch/powerpc/include/asm/topology.h	Thu Nov 20 11:58:09 2008 +1030
+++ b/arch/powerpc/include/asm/topology.h	Thu Nov 20 12:00:50 2008 +1030
@@ -111,8 +111,6 @@
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
-#define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
-#define topology_core_siblings(cpu)	(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)	(&per_cpu(cpu_sibling_map, cpu))
 #define topology_core_cpumask(cpu)	(&per_cpu(cpu_core_map, cpu))
 #define topology_core_id(cpu)		(cpu_to_core_id(cpu))

