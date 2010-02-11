Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0BKMru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:47:50 -0500
Received: from mga06.intel.com ([134.134.136.21]:65379 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753237Ab0BKMrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:47:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,451,1262592000"; 
   d="scan'208";a="491631098"
Date: Thu, 11 Feb 2010 13:49:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] MFD: twl4030-core: Fix a typo in the
 twl_has_pwrbutton definition
Message-ID: <20100211124908.GF3136@sortiz.org>
References: <1265808828-11433-1-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265808828-11433-1-git-send-email-eduardo.valentin@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Wed, Feb 10, 2010 at 03:33:48PM +0200, Eduardo Valentin wrote:
> From: Eduardo Valentin <eduardo.valentin@nokia.com>
> 
> Change the typo CONFIG_INPUT_TWL4030_PWBUTTON_MODULE in the
> twl_has_pwrbutton definition to CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE.
Patch applied manually, as twl4030-core.c is now twl-core.c in my tree,
thanks.

Cheers,
Samuel.


> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  drivers/mfd/twl4030-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index 0004823..04656f8 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -134,7 +134,7 @@
>  #define TWL4030_NUM_SLAVES		4
>  
>  #if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
> -	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
> +	|| defined(CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE)
>  #define twl_has_pwrbutton()	true
>  #else
>  #define twl_has_pwrbutton()	false
> -- 
> 1.6.5.7.g9ecb2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
