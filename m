Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZI0HMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZI0HMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 03:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZI0HMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 03:12:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:59170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZI0HMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 03:12:48 -0400
Message-ID: <4ABF1057.9000803@kernel.org>
Date: Sun, 27 Sep 2009 00:12:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: srat table print out using hex for apic id print out
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



make it consistent with APIC MADT print out
for big system APIC id in hex is more readable

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/srat_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -136,7 +136,7 @@ acpi_numa_x2apic_affinity_init(struct ac
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
@@ -172,7 +172,7 @@ acpi_numa_processor_affinity_init(struct
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
