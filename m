Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYGDLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYGDLsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYGDLsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:48:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5642 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYGDLsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LcqbMhP6W2j/IIxBIRwZ0eHjyK2GfkAPH5uYgbHMPD1jXJMqj/bwOHu8b06UZVJauM
         3je+6JaLwTLAoa0CN6iTAiRIWWqShxe7Le0eU3ap3k8Q6x3czmbdpVLn5hFcWc/EHYe5
         dfKA1Ai3wkhUysep6cfiNx5R9XCKwLncsAqkg=
Date: Fri, 4 Jul 2008 15:47:55 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Message-ID: <20080704114755.GA21747@doriath.ww600.siemens.net>
References: <s5hiqvlc2ut.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hiqvlc2ut.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 01:20:42PM +0200, Takashi Iwai wrote:
> Fix the build of tc6393xb  due to missing definition of struct
> gpio_chip.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 9f93c29..2981da4 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -44,7 +44,7 @@ config HTC_PASIC3
>  
>  config MFD_TC6393XB
>  	bool "Support Toshiba TC6393XB"
> -	depends on HAVE_GPIO_LIB
> +	depends on HAVE_GPIO_LIB && GENERIC_GPIO
>  	select MFD_CORE
>  	help
>  	  Support for Toshiba Mobile IO Controller TC6393XB

Which configuration does provide HAVE_GPIO_LIB but not GENERIC_GPIO?

-- 
With best wishes
Dmitry

