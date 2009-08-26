Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZHZQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZHZQjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZHZQjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:39:52 -0400
Received: from kroah.org ([198.145.64.141]:46868 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZHZQjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:39:52 -0400
Date: Wed, 26 Aug 2009 09:13:55 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samsung-laptop: should include delay.h
Message-ID: <20090826161355.GA22474@kroah.com>
References: <1251194100-15472-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251194100-15472-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 01:55:00PM +0400, Alexander Beregalov wrote:
> Fix this build error:
> drivers/platform/x86/samsung-laptop.c:141: error: implicit declaration of function 'msleep'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>  drivers/platform/x86/samsung-laptop.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index c6f9a86..19e0ef2 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -17,6 +17,7 @@
>  #include <linux/fb.h>
>  #include <linux/dmi.h>
>  #include <linux/platform_device.h>
> +#include <linux/delay.h>

Thanks, I've merged this with the main version of the driver, the next
time it shows up in linux-next (it is currently removed from there at
the moment), it will have this change in it.

thanks,

greg k-h
