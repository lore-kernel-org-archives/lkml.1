Return-Path: <linux-kernel-owner+w=401wt.eu-S935041AbYBBXBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041AbYBBXBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934329AbYBBXAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:00:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:13777 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765359AbYBBXAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MkyWWPN3Oomw350sGN3lladX35aw0cVY8Njx4ThGtnO6inKpCvb0ixtqEBGRhUVOQK5YsvmznOgMbeZfBlcmGHn/9LyN70JWTTeM8f8T0AKigksNX2VcnBgwoFCinNiGCnjsdllS9HbFahPuD3zrN2JvPQdQLG+VN2n0d+8cZU4=
Date: Sun, 3 Feb 2008 02:00:38 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] Use correct clock for IrDA on pxa
Message-ID: <20080202230038.GA16875@doriath.ww600.siemens.net>
References: <20080202225433.GA14685@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202225433.GA14685@doriath.ww600.siemens.net>
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
1.5.3.8


-- 
With best wishes
Dmitry

