Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbXLRQzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbXLRQzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbXLRQxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:53:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760922AbXLRQxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:53:46 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/2] remove __init modifier from header declaration
Date: Tue, 18 Dec 2007 14:52:55 -0200
Message-Id: <11979967763153-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the __init modifier from an extern function
declaration in acpi.h.

Besides not being strictly needed, it requires the inclusion of
linux/init.h, which is usually not even included directly, increasing
header mess by a lot.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/acpi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
index c477e57..2feb0c4 100644
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -158,7 +158,7 @@ extern int acpi_scan_nodes(unsigned long start, unsigned long end);
 #ifdef CONFIG_X86_64
 # define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 #endif
-extern void __init acpi_fake_nodes(const struct bootnode *fake_nodes,
+extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
 				   int num_nodes);
 #else
 static inline void acpi_fake_nodes(const struct bootnode *fake_nodes,
-- 
1.5.0.6

