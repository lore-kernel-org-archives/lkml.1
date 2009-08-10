Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZHJQuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZHJQuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZHJQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:50:09 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:57125 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZHJQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:50:08 -0400
Message-ID: <4A804FEE.8040601@gefanuc.com>
Date: Mon, 10 Aug 2009 17:50:54 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: vme: fix {master,slave}_get check bug
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090810145242.GA22320@braap.org>
In-Reply-To: <20090810145242.GA22320@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> It's checking the wrong functions; fix it.
>
> Signed-off-by: Emilio G. Cota <cota@braap.org>
>   
Acked-by: Martyn Welch <martyn.welch@gefanuc.com>
> ---
>  drivers/staging/vme/vme.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 8ee1192..ed2eeb0 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -338,7 +338,7 @@ int vme_slave_get (struct vme_resource *resource, int *enabled,
>  
>  	image = list_entry(resource->entry, struct vme_slave_resource, list);
>  
> -	if (bridge->slave_set == NULL) {
> +	if (bridge->slave_get == NULL) {
>  		printk("vme_slave_get not supported\n");
>  		return -EINVAL;
>  	}
> @@ -499,7 +499,7 @@ int vme_master_get (struct vme_resource *resource, int *enabled,
>  
>  	image = list_entry(resource->entry, struct vme_master_resource, list);
>  
> -	if (bridge->master_set == NULL) {
> +	if (bridge->master_get == NULL) {
>  		printk("vme_master_set not supported\n");
>  		return -EINVAL;
>  	}
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
