Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbZBFN54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbZBFN54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZBFN5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:57:47 -0500
Received: from mga10.intel.com ([192.55.52.92]:16779 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbZBFN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:57:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="663432221"
Date: Fri, 6 Feb 2009 15:00:10 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix TWL4030 build on some ARM variants
Message-ID: <20090206140009.GF3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1233340937-7679-1-git-send-email-broonie@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233340937-7679-1-git-send-email-broonie@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 06:42:17PM +0000, Mark Brown wrote:
> Many ARM platforms do not provide a mach/cpu.h so rather than guarding
> the use of that header with CONFIG_ARM guard it with the guards used
> when testing for the OMAP variants in the body of the code.
Applied, thanks a lot Mark.

Cheers,
Samuel.
 
> Signed-off-by: Mark Brown <broonie@sirena.org.uk>
> ---
>  drivers/mfd/twl4030-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index e7ab003..68826f1 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -38,7 +38,7 @@
>  #include <linux/i2c.h>
>  #include <linux/i2c/twl4030.h>
>  
> -#ifdef CONFIG_ARM
> +#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
>  #include <mach/cpu.h>
>  #endif
>  
> -- 
> 1.5.6.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
