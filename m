Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345Ab0AETBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0AETBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872Ab0AETBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:01:49 -0500
Received: from mga07.intel.com ([143.182.124.22]:61488 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755165Ab0AETBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:01:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229487904"
Date: Tue, 5 Jan 2010 20:03:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, ian@mnementh.co.uk
Subject: Re: [PATCH] tc6393xb.c: use resource_size()
Message-ID: <20100105190325.GI4274@sortiz.org>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB110D@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB110D@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hartley,

On Fri, Dec 11, 2009 at 07:11:13PM -0500, H Hartley Sweeten wrote:
> Use resource_size() for ioremap.
Patch applied too, many thanks.


> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Molton <ian@mnementh.co.uk>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> 
> ---
> 
> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index 1429a73..50b1610 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -610,7 +610,7 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
>  	if (ret)
>  		goto err_request_scr;
>  
> -	tc6393xb->scr = ioremap(rscr->start, rscr->end - rscr->start + 1);
> +	tc6393xb->scr = ioremap(rscr->start, resource_size(rscr));
>  	if (!tc6393xb->scr) {
>  		ret = -ENOMEM;
>  		goto err_ioremap; 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
