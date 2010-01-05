Return-Path: <linux-kernel-owner+w=401wt.eu-S932152Ab0AETgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab0AETgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076Ab0AETgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:36:12 -0500
Received: from mga05.intel.com ([192.55.52.89]:60186 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932130Ab0AETgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:36:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,224,1262592000"; 
   d="scan'208";a="761546676"
Date: Tue, 5 Jan 2010 20:37:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2.6.33] mfd: Correct WM835x ISINK ramp time defines
Message-ID: <20100105193750.GL4274@sortiz.org>
References: <1262628300-18018-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262628300-18018-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jan 04, 2010 at 06:05:00PM +0000, Mark Brown wrote:
> The constants used to specify ISINK ramp times for WM835x had the
> wrong shifts so that the on times applied to the off ramp and vice
> versa. The masks for the bitfields are correct.
Patch applied to my for-linus branch, thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---
>  include/linux/mfd/wm8350/pmic.h |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mfd/wm8350/pmic.h b/include/linux/mfd/wm8350/pmic.h
> index be3264e..e786fe9 100644
> --- a/include/linux/mfd/wm8350/pmic.h
> +++ b/include/linux/mfd/wm8350/pmic.h
> @@ -666,20 +666,20 @@
>  #define WM8350_ISINK_FLASH_DUR_64MS		(1 << 8)
>  #define WM8350_ISINK_FLASH_DUR_96MS		(2 << 8)
>  #define WM8350_ISINK_FLASH_DUR_1024MS		(3 << 8)
> -#define WM8350_ISINK_FLASH_ON_INSTANT		(0 << 4)
> -#define WM8350_ISINK_FLASH_ON_0_25S		(1 << 4)
> -#define WM8350_ISINK_FLASH_ON_0_50S		(2 << 4)
> -#define WM8350_ISINK_FLASH_ON_1_00S		(3 << 4)
> -#define WM8350_ISINK_FLASH_ON_1_95S		(1 << 4)
> -#define WM8350_ISINK_FLASH_ON_3_91S		(2 << 4)
> -#define WM8350_ISINK_FLASH_ON_7_80S		(3 << 4)
> -#define WM8350_ISINK_FLASH_OFF_INSTANT		(0 << 0)
> -#define WM8350_ISINK_FLASH_OFF_0_25S		(1 << 0)
> -#define WM8350_ISINK_FLASH_OFF_0_50S		(2 << 0)
> -#define WM8350_ISINK_FLASH_OFF_1_00S		(3 << 0)
> -#define WM8350_ISINK_FLASH_OFF_1_95S		(1 << 0)
> -#define WM8350_ISINK_FLASH_OFF_3_91S		(2 << 0)
> -#define WM8350_ISINK_FLASH_OFF_7_80S		(3 << 0)
> +#define WM8350_ISINK_FLASH_ON_INSTANT		(0 << 0)
> +#define WM8350_ISINK_FLASH_ON_0_25S		(1 << 0)
> +#define WM8350_ISINK_FLASH_ON_0_50S		(2 << 0)
> +#define WM8350_ISINK_FLASH_ON_1_00S		(3 << 0)
> +#define WM8350_ISINK_FLASH_ON_1_95S		(1 << 0)
> +#define WM8350_ISINK_FLASH_ON_3_91S		(2 << 0)
> +#define WM8350_ISINK_FLASH_ON_7_80S		(3 << 0)
> +#define WM8350_ISINK_FLASH_OFF_INSTANT		(0 << 4)
> +#define WM8350_ISINK_FLASH_OFF_0_25S		(1 << 4)
> +#define WM8350_ISINK_FLASH_OFF_0_50S		(2 << 4)
> +#define WM8350_ISINK_FLASH_OFF_1_00S		(3 << 4)
> +#define WM8350_ISINK_FLASH_OFF_1_95S		(1 << 4)
> +#define WM8350_ISINK_FLASH_OFF_3_91S		(2 << 4)
> +#define WM8350_ISINK_FLASH_OFF_7_80S		(3 << 4)
>  
>  /*
>   * Regulator Interrupts.
> -- 
> 1.6.5.7
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
