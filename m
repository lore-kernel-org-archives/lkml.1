Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYDCNZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYDCNZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbYDCNYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:24:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:63090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbYDCNYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CAo6WeREoe+V3447oAFEViSmR6qTn7S3+n4UfDc1gJ6+xyTAue32lsZq43oh7bnvqdJ1R/4XECIpxp98X27Y1Mso0Vb9nM1sj5/EwINU42XA/37MB8Izb+J/77rGbxJGikuNVHQl/J8MhxKaQE50gX2DKBNV19twH6/KnprKUP0=
Date: Thu, 3 Apr 2008 17:24:02 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080403132402.GA27008@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403132142.GA26882@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/net/irda/pxaficp_ir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index 8c09344..36d2ec0 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -814,7 +814,7 @@ static int pxa_irda_probe(struct platform_device *pdev)
 	si->dev = &pdev->dev;
 	si->pdata = pdev->dev.platform_data;
 
-	si->sir_clk = clk_get(&pdev->dev, "UARTCLK");
+	si->sir_clk = clk_get(&pdev->dev, "SIRCLK");
 	si->fir_clk = clk_get(&pdev->dev, "FICPCLK");
 	if (IS_ERR(si->sir_clk) || IS_ERR(si->fir_clk)) {
 		err = PTR_ERR(IS_ERR(si->sir_clk) ? si->sir_clk : si->fir_clk);
-- 
1.5.4.4


-- 
With best wishes
Dmitry

