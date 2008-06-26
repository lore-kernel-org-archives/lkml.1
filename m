Return-Path: <linux-kernel-owner+w=401wt.eu-S1761868AbYFZTbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbYFZTbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760324AbYFZT2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:35 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2299 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959AbYFZT2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:32 -0400
X-BigFish: VPS1(zz146fKzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K334QU-03-2Y4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Date: Thu, 26 Jun 2008 21:27:37 +0200
Message-ID: <1214508490-29683-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0440 (UTC) FILETIME=[C5557B00:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Kconfig entry for the AMD IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e0edaaa..5a82f18 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -549,6 +549,13 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
 	  If unsure, say Y.
 
+config AMD_IOMMU
+	bool "AMD IOMMU support"
+	select SWIOTL
+	depends on X86_64 && PCI
+	help
+	  Select this to get support for AMD IOMMU hardware in your system.
+
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
-- 
1.5.3.7


