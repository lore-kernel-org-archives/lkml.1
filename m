Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab0BLQSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:18:43 -0500
Received: from mga10.intel.com ([192.55.52.92]:26743 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753151Ab0BLQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:18:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,462,1262592000"; 
   d="scan'208";a="540258653"
Date: Fri, 12 Feb 2010 17:19:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Balaji T K <balajitk@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Rajendra Nayak <rnayak@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] typo in kernel source (INPUT_TWL4030_PWBUTTON) (resend)
Message-ID: <20100212161951.GB2906@sortiz.org>
References: <20100212151946.GA2502@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212151946.GA2502@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Feb 12, 2010 at 04:19:46PM +0100, Christoph Egger wrote:
> Hi all!
> 
> 	Accoring to my mail-log and a quick look at the mfd tree this
> patch seems to have been lost. I guess it just has been missed among
> other stuff or is anything wrong with it?
I applied this patch yesterday, to my for-next branch.

Cheers,
Samuel.


> ----
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	While working on this we detected a spelling error in
> drivers/mfd/twl-core.c which can be corrected using the attached
> patch.
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
> 
> Regards
> 
> 	Christoph Egger
> 
> [0] http://vamos1.informatik.uni-erlangen.de/
> 
> ----
> From 83cadb82b627f35333742d1585c2f63e40e76ef4 Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Date: Wed, 13 Jan 2010 10:56:27 +0100
> Subject: [PATCH] Correct spelling for config INPUT_TWL4030_PWRBUTTON
> 
> While the non-module variant of the TWL4030 Powerbutton is querried
> with INPUT_TWL4030_PWRBUTTON, the _MODULE variant misses the R and is
> checking therefor INPUT_TWL4030_PWBUTTON which won't work as there's
> nosuch option in kconfig
> 
> Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> ---
>  drivers/mfd/twl-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 2a76065..aeaeac4 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -129,7 +129,7 @@
>  #define TWL_NUM_SLAVES		4
>  
>  #if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
> -	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
> +	|| defined(CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE)
>  #define twl_has_pwrbutton()	true
>  #else
>  #define twl_has_pwrbutton()	false
> -- 
> 1.6.3.3
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
