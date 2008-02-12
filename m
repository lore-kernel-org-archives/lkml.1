Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYBLQo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYBLQo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763050AbYBLQoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:44:11 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53161 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759036AbYBLQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:44:09 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC v3 5/7] dmaengine: Make DMA Engine menu visible for AVR32 users
Date: Tue, 12 Feb 2008 17:43:56 +0100
Message-Id: <1202834638-9009-5-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
 <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
 <1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
 <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/dma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 893a3f8..1a727c1 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig DMADEVICES
 	bool "DMA Engine support"
-	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || AVR32
 	depends on !HIGHMEM64G
 	help
 	  DMA engines can do asynchronous data transfers without
-- 
1.5.3.8

