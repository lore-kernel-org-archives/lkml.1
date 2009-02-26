Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZBZQNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZBZQNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZBZQM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:12:59 -0500
Received: from mga07.intel.com ([143.182.124.22]:12068 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754640AbZBZQM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:12:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,271,1233561600"; 
   d="scan'208";a="114717116"
Date: Thu, 26 Feb 2009 17:15:15 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add support for WM8351 revision B
Message-ID: <20090226161515.GA3114@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1235579015-16193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235579015-16193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I'll apply both patches to my for-next branch, thanks a lot.

Cheers,
Samuel.

On Wed, Feb 25, 2009 at 04:23:34PM +0000, Mark Brown wrote:
> No software visible difference from revision A.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8350-core.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index c384cd2..a285cc0 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1386,6 +1386,11 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  			wm8350->power.rev_g_coeff = 1;
>  			break;
>  
> +		case 1:
> +			dev_info(wm8350->dev, "WM8351 Rev B\n");
> +			wm8350->power.rev_g_coeff = 1;
> +			break;
> +
>  		default:
>  			dev_err(wm8350->dev, "Unknown WM8351 CHIP_REV\n");
>  			ret = -ENODEV;
> -- 
> 1.6.1.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
