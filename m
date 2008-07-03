Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYGCRf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYGCRf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYGCRff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:35:35 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:18195 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbYGCRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:35:33 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K3FY6L-03-NV9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/6] AMD IOMMU: more verbose Kconfig description text
Date: Thu, 3 Jul 2008 19:35:06 +0200
Message-ID: <1215106511-12915-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
References: <1215106511-12915-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2008 17:35:12.0085 (UTC) FILETIME=[256A4050:01C8DD33]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the short description text for AMD IOMMU in Kconfig with a
more verbose one.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dc6425e..c31047a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -568,7 +568,15 @@ config AMD_IOMMU
 	select SWIOTLB
 	depends on X86_64 && PCI && ACPI
 	help
-	  Select this to get support for AMD IOMMU hardware in your system.
+	  With this option you can enable support for AMD IOMMU hardware in
+	  your system. An IOMMU is a hardware component which provides
+	  remapping of DMA memory accesses from devices. With an AMD IOMMU you
+	  can isolate the the DMA memory of different devices and protect the
+	  system from misbehaving device drivers or hardware.
+
+	  You can find out if your system has an AMD IOMMU if you look into
+	  your BIOS for an option to enable it or if you have an IVRS ACPI
+	  table.
 
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
-- 
1.5.3.7


