Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZAAIWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZAAIWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 03:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZAAIWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 03:22:09 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:53860
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbZAAIWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 03:22:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4BALoLXEl8qMVq/2dsb2JhbAAIzAuFcg
X-IronPort-AV: E=Sophos;i="4.36,312,1228057200"; 
   d="scan'208";a="370372299"
Subject: [PATCH] avr32: Remove DMATEST from defconfigs
From: Ben Nizette <bn@niasdigital.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 19:22:21 +1100
Message-Id: <1230798141.16910.97.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the defconfigs for ATNGW100 and ATSTK100[236] the DMA Test driver is
compiled as a module.  This means systems built with *_defconfig +
CONFIG_MODULES=n are unusable as the 3 dma test channels monopolise the
CPU.

I 'spose Haavard uses this module a lot but IMO it isn't really
something needed on all eval boards by default.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---

Please don't hate me if this patch is munged, holiday mailer :-)

 arch/avr32/configs/atngw100_defconfig  |    2 +-
 arch/avr32/configs/atstk1002_defconfig |    2 +-
 arch/avr32/configs/atstk1003_defconfig |    2 +-
 arch/avr32/configs/atstk1006_defconfig |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index 5415209..164e281 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -892,7 +892,7 @@ CONFIG_DMA_ENGINE=y
 # DMA Clients
 #
 # CONFIG_NET_DMA is not set
-CONFIG_DMATEST=m
+# CONFIG_DMATEST is not set
 # CONFIG_UIO is not set
 
 #
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index 69fce6b..c9dc648 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -964,7 +964,7 @@ CONFIG_DMA_ENGINE=y
 # DMA Clients
 #
 # CONFIG_NET_DMA is not set
-CONFIG_DMATEST=m
+# CONFIG_DMATEST is not set
 # CONFIG_UIO is not set
 
 #
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index 5477ed3..29ea132 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -882,7 +882,7 @@ CONFIG_DMA_ENGINE=y
 # DMA Clients
 #
 # CONFIG_NET_DMA is not set
-CONFIG_DMATEST=m
+# CONFIG_DMATEST is not set
 # CONFIG_UIO is not set
 
 #
diff --git a/arch/avr32/configs/atstk1006_defconfig b/arch/avr32/configs/atstk1006_defconfig
index 6c45a3b..361c31c 100644
--- a/arch/avr32/configs/atstk1006_defconfig
+++ b/arch/avr32/configs/atstk1006_defconfig
@@ -1014,7 +1014,7 @@ CONFIG_DMA_ENGINE=y
 # DMA Clients
 #
 # CONFIG_NET_DMA is not set
-CONFIG_DMATEST=m
+# CONFIG_DMATEST is not set
 # CONFIG_UIO is not set
 # CONFIG_STAGING is not set
 CONFIG_STAGING_EXCLUDE_BUILD=y


