Return-Path: <linux-kernel-owner+w=401wt.eu-S934457AbZKXXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934457AbZKXXgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934434AbZKXXgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:36:21 -0500
Received: from mga05.intel.com ([192.55.52.89]:54368 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934422AbZKXXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:36:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,281,1257148800"; 
   d="scan'208";a="750110983"
Date: Wed, 25 Nov 2009 00:37:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] twl4030: fix ELF section mismatch...
Message-ID: <20091124233754.GK8290@sortiz.org>
References: <6278d2220911231054r15891be8k8f8130fd47cddca2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220911231054r15891be8k8f8130fd47cddca2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:54:06PM +0000, Daniel J Blueman wrote:
> Since twl4030_probe is only called from functions in the init ELF
> section, annotate it so.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Mark, thanks for carrying this one with your twl4030 branch.

Cheers,
Samuel.
 
> ---
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index a1c47ee..2fe514d 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -763,7 +763,7 @@ static int twl4030_remove(struct i2c_client *client)
>  }
> 
>  /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
> -static int
> +static int __init
>  twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
>  	int				status;
> -- 
> Daniel J Blueman

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
