Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0BBKSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:18:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab0BBKSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:18:39 -0500
Date: Tue, 2 Feb 2010 11:18:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devres: typo fix s/dev/devm/
In-Reply-To: <cf1ec3a8fa3eb545752984b03cd21abda3997758.1265093593.git.baruch@tkos.co.il>
Message-ID: <alpine.LNX.2.00.1002021118260.15395@pobox.suse.cz>
References: <cf1ec3a8fa3eb545752984b03cd21abda3997758.1265093593.git.baruch@tkos.co.il>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010, Baruch Siach wrote:

> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  kernel/irq/devres.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
> index d06df9c..30d56ba 100644
> --- a/kernel/irq/devres.c
> +++ b/kernel/irq/devres.c
> @@ -81,7 +81,7 @@ EXPORT_SYMBOL(devm_request_threaded_irq);
>   *	Except for the extra @dev argument, this function takes the
>   *	same arguments and performs the same function as free_irq().
>   *	This function instead of free_irq() should be used to manually
> - *	free IRQs allocated with dev_request_irq().
> + *	free IRQs allocated with devm_request_irq().
>   */
>  void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
