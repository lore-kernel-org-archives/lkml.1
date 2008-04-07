Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYDGXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYDGXBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYDGXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:01:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbYDGXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:01:26 -0400
Date: Mon, 7 Apr 2008 16:00:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-Id: <20080407160029.f1f9ce4f.akpm@linux-foundation.org>
In-Reply-To: <20080403132402.GA27008@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	<20080403132402.GA27008@doriath.ww600.siemens.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 17:24:02 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/net/irda/pxaficp_ir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
> index 8c09344..36d2ec0 100644
> --- a/drivers/net/irda/pxaficp_ir.c
> +++ b/drivers/net/irda/pxaficp_ir.c
> @@ -814,7 +814,7 @@ static int pxa_irda_probe(struct platform_device *pdev)
>  	si->dev = &pdev->dev;
>  	si->pdata = pdev->dev.platform_data;
>  
> -	si->sir_clk = clk_get(&pdev->dev, "UARTCLK");
> +	si->sir_clk = clk_get(&pdev->dev, "SIRCLK");
>  	si->fir_clk = clk_get(&pdev->dev, "FICPCLK");
>  	if (IS_ERR(si->sir_clk) || IS_ERR(si->fir_clk)) {
>  		err = PTR_ERR(IS_ERR(si->sir_clk) ? si->sir_clk : si->fir_clk);

When fixing a bug, please describe what the bug is, and how the patch fixes
it.

A patch needs to be very very obvious to be able to get away with no
changelog, and this one is not very very obvious.

