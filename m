Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYGBVVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYGBVVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYGBVSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:40 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:6574 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758377AbYGBVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:38 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDTV-02-CTZ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/11] x86/pci: Makefile merge: Creating pci-y for 64 bit
Date: Wed, 2 Jul 2008 22:50:24 +0200
Message-ID: <1215031829-29124-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:55.0974 (UTC) FILETIME=[18802260:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 0fc3425..844906e 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -33,10 +33,10 @@ else
 obj-y				:= i386.o init.o
 obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_64.o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
-obj-y				+= fixup.o
-obj-$(CONFIG_ACPI)		+= acpi.o
-obj-y				+= legacy.o irq.o
-obj-y				+= common.o early.o
+pci-y				:= fixup.o
+pci-$(CONFIG_ACPI)		+= acpi.o
+pci-y				+= legacy.o irq.o
+obj-y				+= $(pci-y) common.o early.o
 obj-y				+= amd_bus.o
 
 endif
-- 
1.5.5.4


