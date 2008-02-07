Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYBGFnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYBGFnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 00:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYBGFmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 00:42:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:34595 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYBGFmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 00:42:53 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH] [drivers/misc/asus-laptop.c] add parentheses
Date: Thu, 7 Feb 2008 00:42:29 -0500
User-Agent: KMail/1.9.5
Cc: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
References: <47A4CD8A.7060604@tiscali.nl>
In-Reply-To: <47A4CD8A.7060604@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802070042.29667.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-Len

On Saturday 02 February 2008 15:07, Roel Kluin wrote:
> '!' has a higher priority than '&': bitanding has no effect.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
> index 7dce318..65c67d1 100644
> --- a/drivers/misc/asus-laptop.c
> +++ b/drivers/misc/asus-laptop.c
> @@ -322,7 +322,7 @@ static void write_status(acpi_handle handle, int out, int mask)
>  
>  	switch (mask) {
>  	case MLED_ON:
> -		out = !out & 0x1;
> +		out = !(out & 0x1);
>  		break;
>  	case GLED_ON:
>  		out = (out & 0x1) + 1;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
