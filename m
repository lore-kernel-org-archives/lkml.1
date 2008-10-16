Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYJPTdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYJPTdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbYJPTc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:32:56 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:48874 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYJPTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:32:55 -0400
Date: Thu, 16 Oct 2008 15:32:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] sony-laptop: newline-terminate the printk for backlight
 change failure
In-reply-to: <1224184535-30764-1-git-send-email-ajax@redhat.com>
X-X-Sender: lenb@localhost.localdomain
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.1.10.0810161532170.3026@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1224184535-30764-1-git-send-email-ajax@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-len

On Thu, 16 Oct 2008, Adam Jackson wrote:

> ---
>  drivers/misc/sony-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
> index 60775be..5a97d3a 100644
> --- a/drivers/misc/sony-laptop.c
> +++ b/drivers/misc/sony-laptop.c
> @@ -970,7 +970,7 @@ static int sony_nc_resume(struct acpi_device *device)
>  	/* set the last requested brightness level */
>  	if (sony_backlight_device &&
>  			!sony_backlight_update_status(sony_backlight_device))
> -		printk(KERN_WARNING DRV_PFX "unable to restore brightness level");
> +		printk(KERN_WARNING DRV_PFX "unable to restore brightness level\n");
>  
>  	/* re-initialize models with specific requirements */
>  	dmi_check_system(sony_nc_ids);
> -- 
> 1.6.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
