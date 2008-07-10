Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbYGJRBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbYGJRBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbYGJRBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:01:10 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:43484 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbYGJRBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:01:09 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il)
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SV9D-01-VJ4-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/5] x86/pci: Makefile merge: Changing 32bit ordering
Date: Thu, 10 Jul 2008 18:58:23 +0200
Message-ID: <1215709106-9182-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 10 Jul 2008 17:00:50.0633 (UTC) FILETIME=[8195E390:01C8E2AE]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be save since VISWS and NUMAQ exclud each other.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 99d9f09..2a08d2d 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -8,12 +8,11 @@ obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 pci-y				:= fixup.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
+pci-$(CONFIG_X86_NUMAQ)		+= numa.o
 
 # Careful: VISWS overrule the pci-y above. The colons are
 # therefor correct. This needs a proper fix by distangling the code.
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
 
-pci-$(CONFIG_X86_NUMAQ)		+= numa.o
-
 obj-y				+= $(pci-y) common.o early.o
 obj-y				+= amd_bus.o
-- 
1.5.5.4


