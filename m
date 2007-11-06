Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbXKFXSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbXKFXSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXKFXSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:18:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbXKFXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:18:07 -0500
Date: Wed, 7 Nov 2007 08:14:42 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
To: tony@atomide.com
Cc: linux-omap-open-source@linux.omap.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Register the L4 io bus to boot OMAP2
Message-ID: <20071106231442.GA8599@party>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the OMAP2 boot

It is already fixed in OMAP tree. It syncs the mainline tree too.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 5a4091f..69c8174 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -42,6 +42,12 @@ static struct map_desc omap2_io_desc[] __initdata = {
 		.length		= L3_24XX_SIZE,
 		.type		= MT_DEVICE
 	},
+	{
+		.virtual        = L4_24XX_VIRT,
+		.pfn            = __phys_to_pfn(L4_24XX_PHYS),
+		.length         = L4_24XX_SIZE,
+		.type           = MT_DEVICE
+	},
 #ifdef CONFIG_ARCH_OMAP2430
 	{
 		.virtual	= L4_WK_243X_VIRT,
