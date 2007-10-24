Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbXJXUQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbXJXUQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXJXUQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:16:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57611 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753904AbXJXUQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:16:45 -0400
Date: Wed, 24 Oct 2007 22:17:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Message-ID: <20071024201712.GH30533@stusta.de>
References: <200710181401.50470.jbarnes@virtuousgeek.org> <200710191951.45659.jesse.barnes@intel.com> <200710222115.44549.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200710222115.44549.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 09:15:43PM -0700, Jesse Barnes wrote:
> On Friday, October 19, 2007, Jesse Barnes wrote:
> > Dave can you take a look at the new flag and also see what you think
> > about supporting suspend/resume in the event X hasn't started yet?
> > There's some #if 0'd code to support that case, but I haven't tested
> > it.
> 
> Ok Dave, this one's been updated with support for suspend/resume with
> or without X running (iow I removed the requirement that X initialize
> the driver, which DRM drivers usually have).
> 
> Hope it looks alright, it could definitely use testing on more
> machines though...
> 
> Jesse
> 
> diff --git a/linux-core/Kconfig b/linux-core/Kconfig
> index 2d02c76..5e73fc7 100644
> --- a/linux-core/Kconfig
> +++ b/linux-core/Kconfig
> @@ -50,7 +50,7 @@ config DRM_I810
>  
>  choice
>  	prompt "Intel 830M, 845G, 852GM, 855GM, 865G"
> -	depends on DRM && AGP && AGP_INTEL
> +	depends on DRM && AGP && AGP_INTEL && !FB_INTEL
>  	optional
>...

This sounds like a bad regression.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

