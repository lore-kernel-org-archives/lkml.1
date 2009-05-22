Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZEVMNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZEVMNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZEVMNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:01 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62336 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZEVMNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:00 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KK1OLF-03-92O-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>, David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/7] x86/iommu: add IOMMU_STRESS Kconfig entry
Date: Fri, 22 May 2009 14:12:48 +0200
Message-ID: <1242994369-28697-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
References: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:12:50.0168 (UTC) FILETIME=[A0292F80:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: add a Kconfig option to enable stress-test code im iommu drivers ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/Kconfig.debug |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 5865712..33fac6b 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -159,6 +159,14 @@ config IOMMU_DEBUG
 	  options. See Documentation/x86_64/boot-options.txt for more
 	  details.
 
+config IOMMU_STRESS
+	bool "Enable IOMMU stress-test mode"
+	---help---
+	  This option disables various optimizations in IOMMU related
+	  code to do real stress testing of the IOMMU code. This option
+	  will cause a performance drop and should only be enabled for
+	  testing.
+
 config IOMMU_LEAK
 	bool "IOMMU leak tracing"
 	depends on IOMMU_DEBUG && DMA_API_DEBUG
-- 
1.6.3.1


