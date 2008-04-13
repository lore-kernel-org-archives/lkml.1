Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYDMOom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYDMOom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbYDMOns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:43:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759211AbYDMOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EznZ/4Kr62hgs1kKAvk6OwcMYA1eg9gh8/eZsfqLKtteoV3FhhawIdmpAwu+RsdkW3fOK+6HnTJhbSWWzB53qCXAYcwXRkOLhEIPwpWReKM8Gwl8IEoIJB4SvfFCWv5YFyUwSBf2YeAyaUslT27UHGdeyBbzgmUCSD9ApUoyIJs=
Date: Sun, 13 Apr 2008 18:43:36 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: [PATCH 5/5] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080413144336.GA1997@doriath.ww600.siemens.net>
References: <20080413144138.GA31665@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413144138.GA31665@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/net/irda/pxaficp_ir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index 8db71ab..1aae2d6 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -815,7 +815,7 @@ static int pxa_irda_probe(struct platform_device *pdev)
 	si->dev = &pdev->dev;
 	si->pdata = pdev->dev.platform_data;
 
-	si->sir_clk = clk_get(&pdev->dev, "UARTCLK");
+	si->sir_clk = clk_get(&pdev->dev, "STUARTCLK");
 	si->fir_clk = clk_get(&pdev->dev, "FICPCLK");
 	if (IS_ERR(si->sir_clk) || IS_ERR(si->fir_clk)) {
 		err = PTR_ERR(IS_ERR(si->sir_clk) ? si->sir_clk : si->fir_clk);
-- 
1.5.4.4


-- 
With best wishes
Dmitry

