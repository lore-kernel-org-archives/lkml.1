Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYLDGr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYLDGr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYLDGrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:47:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:59110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbYLDGrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:47:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QLhGpDFB3CcsI96Q+V1ghmvWjSPERNdVJGFSsEYMy9nshN4x4gtwGoeL8oRlBBkVH0
         tgfXLqzoXQoGubH0kH7JNcD6q/n1hfw+m5mwxG1uMnCHp4n2OSCpHvlEAk8E1FBHZwIK
         SDcfrm/eXL1cdpYxciezto67zeWCzaHtCyuJg=
Date: Thu, 4 Dec 2008 09:46:43 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] [STAGING] Move staging drivers back to
	staging-specific menu
Message-ID: <20081204064643.GA29338@doriath.ww600.siemens.net>
References: <1227819688-24035-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227819688-24035-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 28, 2008 at 12:01:28AM +0300, Dmitry Baryshkov wrote:
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/staging/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

What about this patch? I don't see it in linux-next

> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index c95b286..4089f14 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -22,6 +22,8 @@ menuconfig STAGING
>  	  If in doubt, say N here.
>  
>  
> +if STAGING
> +
>  config STAGING_EXCLUDE_BUILD
>  	bool "Exclude Staging drivers from being built" if STAGING
>  	default y
> @@ -37,8 +39,6 @@ config STAGING_EXCLUDE_BUILD
>  	  when selecting 'make allyesconfg' and 'make allmodconfig' so
>  	  don't be all that put off, your dog will be just fine.
>  
> -if !STAGING_EXCLUDE_BUILD
> -
>  source "drivers/staging/et131x/Kconfig"
>  
>  source "drivers/staging/slicoss/Kconfig"
> -- 
> 1.5.6.5
> 

-- 
With best wishes
Dmitry

