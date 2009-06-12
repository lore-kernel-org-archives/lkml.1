Return-Path: <linux-kernel-owner+w=401wt.eu-S1765294AbZFLN3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765294AbZFLN3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZFLNZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:57 -0400
Received: from ozlabs.org ([203.10.76.45]:54987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763091AbZFLNZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:56 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 13/17] cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: core
Message-Id: <20090612132558.2856BDDD1C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There were replaced by topology_core_cpumask and topology_thread_cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/topology.h |    6 ------
 1 file changed, 6 deletions(-)

diff -r b1d85f253cf2 include/linux/topology.h
--- a/include/linux/topology.h	Thu Nov 20 11:58:09 2008 +1030
+++ b/include/linux/topology.h	Thu Nov 20 12:00:50 2008 +1030
@@ -185,12 +185,6 @@
 #ifndef topology_core_id
 #define topology_core_id(cpu)			((void)(cpu), 0)
 #endif
-#ifndef topology_thread_siblings
-#define topology_thread_siblings(cpu)		cpumask_of_cpu(cpu)
-#endif
-#ifndef topology_core_siblings
-#define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
-#endif
 #ifndef topology_thread_cpumask
 #define topology_thread_cpumask(cpu)		cpumask_of(cpu)
 #endif

