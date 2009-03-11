Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZCKWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZCKWCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZCKV6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:23 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:41075 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754355AbZCKV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:21 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: iNFcLmAVM1mcFurlXD5HrW.G17aBPebbgJ5rALzvl4AXNaEwKsiE_n50mCfsIZBggC03iatGccrEI8upMPBaHu1.8_LXpHMaGovO9AFthDbvLO3Z42t.payjwDOCcnn7pN1rTWtT0HphjpIL_Lx2R.kVDGIGzoGnZo1WT_ipP58tUEcBjAF6qsdKXolfjmOijC3qwwxnbXUdyLosWheP5r0MLg--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 12/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:56:09 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Organization: fdwdc.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111456.10075.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/arch/m68knommu/platform/532x/config.c 
b/arch/m68knommu/platform/532x/config.c
index a347623..0cd97c5 100644
--- a/arch/m68knommu/platform/532x/config.c
+++ b/arch/m68knommu/platform/532x/config.c
@@ -383,8 +383,8 @@ void gpio_init(void)
 	/* Initialize TIN3 as a GPIO output to enable the write
 	   half of the latch */
 	MCF_GPIO_PAR_TIMER = 0x00;
-	MCF_GPIO_PDDR_TIMER = 0x08;
-	MCF_GPIO_PCLRR_TIMER = 0x0;
+	__raw_writeb(0x08, MCFGPIO_PDDR_TIMER);
+	__raw_writeb(0x00, MCFGPIO_PCLRR_TIMER);
 
 }
-- 
Steven King -- sfking at fdwdc dot com
