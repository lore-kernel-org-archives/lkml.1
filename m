Return-Path: <linux-kernel-owner+w=401wt.eu-S932088Ab0AETB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0AETB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215Ab0AETBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:01:24 -0500
Received: from mga07.intel.com ([143.182.124.22]:50355 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755324Ab0AETBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:01:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229487728"
Date: Tue, 5 Jan 2010 20:03:01 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, ian@mnementh.co.uk
Subject: Re: [PATCH] t7l66xb.c: use resource_size()
Message-ID: <20100105190300.GH4274@sortiz.org>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB110A@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB110A@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hartley,

On Fri, Dec 11, 2009 at 07:07:32PM -0500, H Hartley Sweeten wrote:
> Use resource_size() for ioremap.
Patch applied, thanks.


> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Molton <ian@mnementh.co.uk>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> 
> ---
> 
> diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
> index 0a255c1..20bbd1d 100644
> --- a/drivers/mfd/t7l66xb.c
> +++ b/drivers/mfd/t7l66xb.c
> @@ -341,7 +341,7 @@ static int t7l66xb_probe(struct platform_device *dev)
>  	if (ret)
>  		goto err_request_scr;
>  
> -	t7l66xb->scr = ioremap(rscr->start, rscr->end - rscr->start + 1);
> +	t7l66xb->scr = ioremap(rscr->start, resource_size(rscr));
>  	if (!t7l66xb->scr) {
>  		ret = -ENOMEM;
>  		goto err_ioremap; 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
