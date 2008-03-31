Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYCaIp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYCaIp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYCaIpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:45:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:35645 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbYCaIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IP5cnjlZ3/dys9yuE6ZETTuMegEszHyeB1yrpibz8KoQt/JGbQo39BOKPPeXx6fhXtOH/jdAzWCVzJa/KET7Lq2WfIoYuBH97M5o+aADb9iKnbl1OaCskiVU+2UuJkKfYJpo24JE78j4z81V8zn8Fr10jMGNo0yGOcNR/Og8xog=
Date: Mon, 31 Mar 2008 12:44:55 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080331084455.GA11657@doriath.ww600.siemens.net>
References: <20080331083947.GA11282@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331083947.GA11282@doriath.ww600.siemens.net>
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

