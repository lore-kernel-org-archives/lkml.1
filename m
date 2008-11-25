Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYKYLZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYKYLZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYKYLZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:25:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:62564 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYKYLZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:25:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=inpvqlEdgRmpd2PpuXki2uPWUMSDwWFRjmldcBH+i6NQln1hCDcZ534PbIkpuNzXNR
         eNFUVD6Xa3Sf1daOOcs6SyK+2GmPqFVy7+oJCWU2sHWPPfthQHdtcQYRplsHFjFC6qea
         K6nNT+hcSEPASijhdVwZmcLwjyGnWf0GrTnfM=
Date: Tue, 25 Nov 2008 14:25:12 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] power_supply: Add cold to the POWER_SUPPLY_HEALTH
	report values
Message-ID: <20081125112512.GA1110@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20081120152044.GA15434@rakim.wolfsonmicro.main> <1227194621-16442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1227194621-16442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 03:23:40PM +0000, Mark Brown wrote:
> Some systems are able to report problems with batteries being under
> temperature.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looks good to me.

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

> ---
>  drivers/power/power_supply_sysfs.c |    2 +-
>  include/linux/power_supply.h       |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 23ae846..ac01e06 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -45,7 +45,7 @@ static ssize_t power_supply_show_property(struct device *dev,
>  	};
>  	static char *health_text[] = {
>  		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
> -		"Unspecified failure"
> +		"Unspecified failure", "Cold",
>  	};
>  	static char *technology_text[] = {
>  		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index f9348cb..8ff25e0 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -45,6 +45,7 @@ enum {
>  	POWER_SUPPLY_HEALTH_DEAD,
>  	POWER_SUPPLY_HEALTH_OVERVOLTAGE,
>  	POWER_SUPPLY_HEALTH_UNSPEC_FAILURE,
> +	POWER_SUPPLY_HEALTH_COLD,
>  };
>  
>  enum {
> -- 
> 1.5.6.5
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
