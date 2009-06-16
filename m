Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZFPJPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZFPJPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZFPJPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:15:37 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:37184 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZFPJPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:15:36 -0400
Subject: Re: [PATCH] regulator: add check index of wm8350->pmic.pdev[]
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A36AF6F.6060005@gmail.com>
References: <4A36AF6F.6060005@gmail.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 10:15:35 +0100
Message-Id: <1245143735.21421.94.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 22:30 +0200, Roel Kluin wrote:
> Ensure that reg is within the bounds of array wm8350->pmic.pdev[].
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
> index 771eca1..c806259 100644
> --- a/drivers/regulator/wm8350-regulator.c
> +++ b/drivers/regulator/wm8350-regulator.c
> @@ -1419,6 +1419,8 @@ int wm8350_register_regulator(struct wm8350 *wm8350, int reg,
>  {
>  	struct platform_device *pdev;
>  	int ret;
> +	if (reg < 0 || reg >= NUM_WM8350_REGULATORS)
> +		return -EINVAL;
>  
>  	if (wm8350->pmic.pdev[reg])
>  		return -EBUSY;

Applied.

Thanks.

Liam

