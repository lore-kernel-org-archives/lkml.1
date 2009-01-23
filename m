Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZAWK5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZAWK5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZAWK4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:56:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:43383 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZAWK4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:56:51 -0500
X-IronPort-AV: E=Sophos;i="4.37,311,1231131600"; 
   d="scan'208";a="36900991"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: rename arch/x86/kernel/pci-swiotlb_64.o => pci-swiotlb.o
Date: Fri, 23 Jan 2009 10:56:16 +0000
Message-Id: <1232708176-26379-1-git-send-email-Ian.Campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 23 Jan 2009 10:56:50.0142 (UTC) FILETIME=[4B042FE0:01C97D49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file is used for 32 and 64 bit since:

  commit cfb80c9eae8c7ed8f2ee81090062d15ead51cbe8
  Author: Jeremy Fitzhardinge <jeremy@goop.org>
  Date:   Tue Dec 16 12:17:36 2008 -0800

    x86: unify pci iommu setup and allow swiotlb to compile for 32 bit

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/Makefile                           |    2 +-
 .../x86/kernel/{pci-swiotlb_64.c => pci-swiotlb.c} |    0 
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/x86/kernel/{pci-swiotlb_64.c => pci-swiotlb.c} (100%)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index d364df0..bb1eef6 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -109,7 +109,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
 
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
-obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb_64.o # NB rename without _64
+obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb.c
similarity index 100%
rename from arch/x86/kernel/pci-swiotlb_64.c
rename to arch/x86/kernel/pci-swiotlb.c
-- 
1.5.6.5

