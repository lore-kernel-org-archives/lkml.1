Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZKWLwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZKWLwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbZKWLwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:52:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:55975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166AbZKWLwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:52:39 -0500
Date: Mon, 23 Nov 2009 11:52:15 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B07A739.3030104@kernel.org>
References: <4B07A739.3030104@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: apic: Print out SRAT table APIC id in hex
Message-ID: <tip-163d3866cfa79aa5945f1ee5e43fb3ed1455f75c@git.kernel.org>
Git-Commit-ID: 163d3866cfa79aa5945f1ee5e43fb3ed1455f75c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  163d3866cfa79aa5945f1ee5e43fb3ed1455f75c
Gitweb:     http://git.kernel.org/tip/163d3866cfa79aa5945f1ee5e43fb3ed1455f75c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 21 Nov 2009 00:23:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 09:56:30 +0100

x86: apic: Print out SRAT table APIC id in hex

Make it consistent with APIC MADT print out,
for big systems APIC id in hex is more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B07A739.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/srat_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index dbb5381..9d7ce96 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -136,7 +136,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
@@ -170,7 +170,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
 	       pxm, apic_id, node);
 }
 
