Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbXKWMVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbXKWMVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXKWMV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:21:29 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62005 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757050AbXKWMV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:21:28 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC 2/4] dmaengine: Make DMA Engine menu visible for AVR32 users
Date: Fri, 23 Nov 2007 13:20:11 +0100
Message-Id: <1195820413-2179-3-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com>
 <1195820413-2179-2-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/dma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1db5499..9bcc392 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig DMADEVICES
 	bool "DMA Engine support"
-	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || AVR32
 	help
 	  DMA engines can do asynchronous data transfers without
 	  involving the host CPU. This can be used to offload memory
-- 
1.5.3.4

