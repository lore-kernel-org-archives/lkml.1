Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYLOOYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYLOOYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbYLOOTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:12 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:13871 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbYLOOTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:09 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBX938-03-00L-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/22] AMD IOMMU: add Kconfig entry for statistic collection code
Date: Mon, 15 Dec 2008 15:17:51 +0100
Message-ID: <1229350685-3816-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0088 (UTC) FILETIME=[F2BB1080:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: adds new Kconfig entry

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b9f7187..de65e30 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -567,6 +567,16 @@ config AMD_IOMMU
 	  your BIOS for an option to enable it or if you have an IVRS ACPI
 	  table.
 
+config AMD_IOMMU_STATS
+	bool "Export AMD IOMMU statistics to debugfs"
+	depends on AMD_IOMMU
+	select DEBUG_FS
+	help
+	  This option enables code in the AMD IOMMU driver to collect various
+	  statistics about whats happening in the driver and exports that
+	  information to userspace via debugfs.
+	  If unsure, say N.
+
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
-- 
1.5.6.4


