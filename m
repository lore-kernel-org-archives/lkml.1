Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZLKOiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZLKOiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbZLKOiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:38:08 -0500
Received: from chipmunk.wormnet.eu ([195.195.131.226]:54011 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbZLKOiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:38:07 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 09:38:07 EST
Date: Fri, 11 Dec 2009 14:32:04 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] timeriomem-rng.c: use resource_size()
Message-ID: <20091211143204.GW993@chipmunk>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB0FBA@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB0FBA@mi8nycmail19.Mi8.com>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* H Hartley Sweeten <hartleys@visionengravers.com> [2009-12-10 20:16:54-0500]:
>
> Use resource_size() for ioremap.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alexander Clouter <alex@digriz.org.uk>
> 
Acked-by: Alexander Clouter <alex@digriz.org.uk>

> diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
> index a94e930..a8428e6 100644
> --- a/drivers/char/hw_random/timeriomem-rng.c
> +++ b/drivers/char/hw_random/timeriomem-rng.c
> @@ -100,8 +100,7 @@ static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
>  
>  	timeriomem_rng_data = pdev->dev.platform_data;
>  
> -	timeriomem_rng_data->address = ioremap(res->start,
> -						res->end - res->start + 1);
> +	timeriomem_rng_data->address = ioremap(res->start, resource_size(res));
>  	if (!timeriomem_rng_data->address)
>  		return -EIO;

-- 
Alexander Clouter
.sigmonster says: Every time I think I know where it's at, they move it.
