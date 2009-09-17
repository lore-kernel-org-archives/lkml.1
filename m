Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZIQI5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZIQI5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZIQI5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:57:05 -0400
Received: from mga06.intel.com ([134.134.136.21]:57156 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752870AbZIQI5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:57:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,402,1249282800"; 
   d="scan'208";a="449274372"
Date: Thu, 17 Sep 2009 10:58:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] Voltage count for AB3100 regulator
Message-ID: <20090917085854.GA18862@sortiz.org>
References: <1253171853-27525-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253171853-27525-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Sep 17, 2009 at 09:17:33AM +0200, Linus Walleij wrote:
> This sets the number of voltages for the AB3100 regulators so that
> they play well with the voltage listing functions and can be used
> properly with the MMC regulator integration glue for example.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> The MFD update containing the AB3100 regulator patch has not yet
> hit mainline so I guess we'll have to queue this up in Sam's tree
> too if it's not changing in the next few hours, OK Sam?
Patch applied.
I am going to send my pull request to Linus today, yours was the last one I
take for this merge window.

Cheers,
Samuel.


> ---
>  drivers/regulator/ab3100.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
> index 156979d..49aeee8 100644
> --- a/drivers/regulator/ab3100.c
> +++ b/drivers/regulator/ab3100.c
> @@ -521,30 +521,35 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
>  		.name = "LDO_E",
>  		.id   = AB3100_LDO_E,
>  		.ops  = &regulator_ops_variable_sleepable,
> +		.n_voltages = ARRAY_SIZE(ldo_e_buck_typ_voltages),
>  		.type = REGULATOR_VOLTAGE,
>  	},
>  	{
>  		.name = "LDO_F",
>  		.id   = AB3100_LDO_F,
>  		.ops  = &regulator_ops_variable,
> +		.n_voltages = ARRAY_SIZE(ldo_f_typ_voltages),
>  		.type = REGULATOR_VOLTAGE,
>  	},
>  	{
>  		.name = "LDO_G",
>  		.id   = AB3100_LDO_G,
>  		.ops  = &regulator_ops_variable,
> +		.n_voltages = ARRAY_SIZE(ldo_g_typ_voltages),
>  		.type = REGULATOR_VOLTAGE,
>  	},
>  	{
>  		.name = "LDO_H",
>  		.id   = AB3100_LDO_H,
>  		.ops  = &regulator_ops_variable,
> +		.n_voltages = ARRAY_SIZE(ldo_h_typ_voltages),
>  		.type = REGULATOR_VOLTAGE,
>  	},
>  	{
>  		.name = "LDO_K",
>  		.id   = AB3100_LDO_K,
>  		.ops  = &regulator_ops_variable,
> +		.n_voltages = ARRAY_SIZE(ldo_k_typ_voltages),
>  		.type = REGULATOR_VOLTAGE,
>  	},
>  	{
> @@ -557,6 +562,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
>  		.name = "BUCK",
>  		.id   = AB3100_BUCK,
>  		.ops  = &regulator_ops_variable_sleepable,
> +		.n_voltages = ARRAY_SIZE(ldo_e_buck_typ_voltages),
>  		.type = REGULATOR_VOLTAGE,
>  	},
>  };
> -- 
> 1.6.2.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
