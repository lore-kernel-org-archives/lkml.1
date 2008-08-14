Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYHNBND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYHNBND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbYHNBMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:12:53 -0400
Received: from mga10.intel.com ([192.55.52.92]:20132 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966AbYHNBMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:12:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,204,1217833200"; 
   d="scan'208";a="606603415"
Date: Thu, 14 Aug 2008 09:11:00 +0800
From: Kent Liu <kent.liu@linux.intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] coretemp: Recognize Nehalem CPUs
Message-ID: <20080814011100.GB14828@wliu-linux.bj.intel.com>
References: <20080813225147.GE28450@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813225147.GE28450@tree.beaverton.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 03:51:48PM -0700, Darrick J. Wong wrote:
> Add in the CPUID for Nehalem chips.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/coretemp.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 70239ac..9f2e423 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -416,7 +416,8 @@ static int __init coretemp_init(void)
>  		/* check if family 6, models 0xe, 0xf, 0x16, 0x17 */
This comment should be updated as well to include 0x1A.
>  		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
>  		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
> -			(c->x86_model == 0x16) || (c->x86_model == 0x17))) {
> +			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
> +			(c->x86_model == 0x1A))) {
>  
>  			/* supported CPU not found, but report the unknown
>  			   family 6 CPU */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
