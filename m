Return-Path: <linux-kernel-owner+w=401wt.eu-S1764899AbZFLNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764899AbZFLNbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbZFLN0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:02 -0400
Received: from ozlabs.org ([203.10.76.45]:54990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761523AbZFLNZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:59 -0400
CC: linux-kernel@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:05 +0930
Subject: [PATCH 15/17] cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: s390
Message-Id: <20090612132601.B1262DDD1C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There were replaced by topology_core_cpumask and topology_thread_cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/s390/include/asm/topology.h |    1 -
 1 file changed, 1 deletion(-)

diff -r b1d85f253cf2 arch/s390/include/asm/topology.h
--- a/arch/s390/include/asm/topology.h	Thu Nov 20 11:58:09 2008 +1030
+++ b/arch/s390/include/asm/topology.h	Thu Nov 20 12:00:50 2008 +1030
@@ -9,7 +9,6 @@
 
 extern cpumask_t cpu_core_map[NR_CPUS];
 
-#define topology_core_siblings(cpu)	(cpu_core_map[cpu])
 #define topology_core_cpumask(cpu)	(&cpu_core_map[cpu])
 
 int topology_set_cpu_management(int fc);

