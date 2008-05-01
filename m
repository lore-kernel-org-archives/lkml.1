Return-Path: <linux-kernel-owner+w=401wt.eu-S1765123AbYEATcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765123AbYEATcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbYEATb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:31:56 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48350 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbYEATb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:31:56 -0400
Date: Thu, 1 May 2008 22:31:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andres Freund <andres@anarazel.de>
Cc: linux-kernel@vger.kernel.org, apdim@grecian.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] v4l/dvb: Add linux/version.h include as KERNEL_VERSION
	macro is used.
Message-ID: <20080501193107.GN29330@cs181133002.pp.htv.fi>
References: <200805012005.42400.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805012005.42400.andres@anarazel.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 08:05:41PM +0200, Andres Freund wrote:
> Whitout this build fails with unknown macro on 
> e4c576b911e364737b1bf4f5bfdab1c440713f26
> 
> Hopefully I did everything correct, as this is my first usage of git beside 
> checking out. Also its my first patch on lk....
> 
> Is an Signed-off-by already appropriate with such an trivial change?

Yes.

> Signed-off-by: Andres Freund <andres@anarazel.de>
> ---
>  drivers/media/radio/radio-maxiradio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-maxiradio.c 
> b/drivers/media/radio/radio-maxiradio.c
> index 0133ecf..e170fcd 100644
> --- a/drivers/media/radio/radio-maxiradio.c
> +++ b/drivers/media/radio/radio-maxiradio.c
> @@ -34,6 +34,7 @@
>  
>  
>  #include <linux/module.h>
> +#include <linux/version.h>
>  #include <linux/init.h>
>  #include <linux/ioport.h>
>  #include <linux/delay.h>

The #include is already there a dozen lines below.

It seems to be missing in another file.

Can you send the error message and your .config?

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

