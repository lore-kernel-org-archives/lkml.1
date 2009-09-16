Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZIPIT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZIPIT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZIPIT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:19:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52029 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZIPITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:19:22 -0400
Date: Wed, 16 Sep 2009 17:19:25 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 2/3] ARM: SMDKC100: add dma platform devices
To: linux-arm-kernel@lists.infradead.org
Cc: ben-linux@fluff.org, dan.j.williams@intel.com, kyungmin.park@samsung.com,
       bhmin@samsung.com, linux-kernel@vger.kernel.org
Message-id: <4AB09F8D.5070005@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 16 Sep 2009 08:19:25.0175 (UTC)
 FILETIME=[66DD9870:01CA36A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds three dma platform devices for s5pc1xx dma on smdkc100
board file.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 arch/arm/mach-s5pc100/mach-smdkc100.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pc100/mach-smdkc100.c b/arch/arm/mach-s5pc100/mach-smdkc100.c
index 214093c..7771a6f 100644
--- a/arch/arm/mach-s5pc100/mach-smdkc100.c
+++ b/arch/arm/mach-s5pc100/mach-smdkc100.c
@@ -76,6 +76,9 @@ static struct s3c2410_uartcfg smdkc100_uartcfgs[] __initdata = {
 static struct map_desc smdkc100_iodesc[] = {};
 
 static struct platform_device *smdkc100_devices[] __initdata = {
+	&s5pc1xx_device_mdma,
+	&s5pc1xx_device_pdma0,
+	&s5pc1xx_device_pdma1,
 };
 
 static void __init smdkc100_map_io(void)
-- 
1.6.0.4
