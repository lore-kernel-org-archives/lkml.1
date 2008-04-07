Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbYDGXDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbYDGXDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYDGXCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:02:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbYDGXCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:02:53 -0400
Date: Mon, 7 Apr 2008 16:01:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 6/6] Clocklib: use correct name for 3,6MHz clock
Message-Id: <20080407160155.5e6d77f0.akpm@linux-foundation.org>
In-Reply-To: <20080403132411.GA27017@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	<20080403132411.GA27017@doriath.ww600.siemens.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 17:24:11 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  arch/arm/common/sa1111.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index eb06d0b..282a4d9 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -627,7 +627,7 @@ __sa1111_probe(struct device *me, struct resource *mem, int irq)
>  	if (!sachip)
>  		return -ENOMEM;
>  
> -	sachip->clk = clk_get(me, "GPIO27_CLK");
> +	sachip->clk = clk_get(me, "3_6MHz_CLK");
>  	if (!sachip->clk) {
>  		ret = PTR_ERR(sachip->clk);
>  		goto err_free;

Again, there's just not enough information for us (well: me) to be able to
evaluate this patch.

For example, if the current name is "incorrect" then why shouldn't we fix
it in 2.6.25?  2.6.24?  etc.

