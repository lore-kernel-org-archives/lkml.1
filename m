Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZJUW1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZJUW1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZJUW1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:27:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:50108 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755588AbZJUW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,600,1249282800"; 
   d="scan'208";a="505969366"
Date: Thu, 22 Oct 2009 00:29:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Allow platforms to specify an IRQ base for WM8350
Message-ID: <20091021222910.GE17796@sortiz.org>
References: <1256148694-23312-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256148694-23312-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Oct 21, 2009 at 07:11:34PM +0100, Mark Brown wrote:
> This is currently unused by the wm8350 drivers but getting it merged
> now will reduce merge issues in the future when implementing wm8350
> genirq support.
Patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/mfd/wm8350/core.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
> index 32197fd..ffce508 100644
> --- a/include/linux/mfd/wm8350/core.h
> +++ b/include/linux/mfd/wm8350/core.h
> @@ -646,10 +646,12 @@ struct wm8350 {
>   * @init: Function called during driver initialisation.  Should be
>   *        used by the platform to configure GPIO functions and similar.
>   * @irq_high: Set if WM8350 IRQ is active high.
> + * @irq_base: Base IRQ for genirq (not currently used).
>   */
>  struct wm8350_platform_data {
>  	int (*init)(struct wm8350 *wm8350);
>  	int irq_high;
> +	int irq_base;
>  };
>  
>  
> -- 
> 1.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
