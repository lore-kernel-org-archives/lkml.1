Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbZFLNbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbZFLNbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763143AbZFLN0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:04 -0400
Received: from ozlabs.org ([203.10.76.45]:54991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763310AbZFLNZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:59 -0400
CC: linux-kernel@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 3/17] cpumask: remove the now-obsoleted pcibus_to_cpumask(): powerpc
Message-Id: <20090612132601.0A4A7DDDB2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpumask_of_pcibus() is the new version.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/powerpc/include/asm/topology.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -35,11 +35,6 @@ static inline int pcibus_to_node(struct 
 	return -1;
 }
 #endif
-
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)) \
-				)
 
 #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
 				 cpu_all_mask :				\

