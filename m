Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbZFLNdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbZFLNdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760672AbZFLN0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:07 -0400
Received: from ozlabs.org ([203.10.76.45]:54995 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763205AbZFLN0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:26:01 -0400
CC: linux-kernel@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 2/17] cpumask: remove the now-obsoleted pcibus_to_cpumask(): mips
Message-Id: <20090612132603.444BBDDDE2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpumask_of_pcibus() is the new version.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -29,7 +29,6 @@ struct pci_bus;
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
 
-#define pcibus_to_cpumask(bus)	(cpu_online_map)
 #define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];

