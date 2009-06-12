Return-Path: <linux-kernel-owner+w=401wt.eu-S1765316AbZFLN31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765316AbZFLN31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763297AbZFLNZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:58 -0400
Received: from ozlabs.org ([203.10.76.45]:54981 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761523AbZFLNZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:56 -0400
CC: linux-kernel@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 4/17] cpumask: remove the now-obsoleted pcibus_to_cpumask(): sh
Message-Id: <20090612132556.EEAEADDD04@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpumask_of_pcibus() is the new version.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/sh/include/asm/topology.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -35,9 +35,6 @@
 #define cpumask_of_node(node)	((void)node, cpu_online_mask)
 
 #define pcibus_to_node(bus)	((void)(bus), -1)
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)))
 #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ? \
 					CPU_MASK_ALL_PTR : \
 					cpumask_of_node(pcibus_to_node(bus)))

