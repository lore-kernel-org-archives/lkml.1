Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYGKLJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYGKLJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbYGKLCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:46 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37045 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbYGKLCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:45 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U9C6-01-XCV-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86/pci: Removing pci-y in Makefile
Date: Fri, 11 Jul 2008 12:13:59 +0200
Message-ID: <1215771239-27725-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 11 Jul 2008 11:02:15.0038 (UTC) FILETIME=[93B461E0:01C8E345]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index e515e8d..28451f4 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -5,13 +5,13 @@ obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 
-pci-y				:= fixup.o
-pci-$(CONFIG_ACPI)		+= acpi.o
-pci-y				+= legacy.o irq.o
+obj-y				+= fixup.o
+obj-$(CONFIG_ACPI)		+= acpi.o
+obj-y				+= legacy.o irq.o
 
-pci-$(CONFIG_X86_VISWS)		+= visws.o
+obj-$(CONFIG_X86_VISWS)		+= visws.o
 
-pci-$(CONFIG_X86_NUMAQ)		+= numa.o
+obj-$(CONFIG_X86_NUMAQ)		+= numa.o
 
-obj-y				+= $(pci-y) common.o early.o
+obj-y				+= common.o early.o
 obj-y				+= amd_bus.o
-- 
1.5.5.4


