Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbXLFNYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbXLFNYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 08:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXLFNYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 08:24:34 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:28664 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXLFNYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 08:24:33 -0500
Date: Thu, 6 Dec 2007 08:21:02 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Roger Lucas <roger@planbit.co.uk>,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 15/59] drivers/hwmon: Add missing "space"
Message-ID: <20071206132102.GD7021@jupiter.solarsys.private>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <e2a957ca2937d67956712a66e7388dcd2f95cf90.1195454435.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a957ca2937d67956712a66e7388dcd2f95cf90.1195454435.git.joe@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches <joe@perches.com> [2007-11-19 17:48:07 -0800]:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/vt8231.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
> index 2196a84..f876617 100644
> --- a/drivers/hwmon/vt8231.c
> +++ b/drivers/hwmon/vt8231.c
> @@ -504,7 +504,7 @@ static ssize_t set_fan_div(struct device *dev, struct device_attribute *attr,
>  	case 4: data->fan_div[nr] = 2; break;
>  	case 8: data->fan_div[nr] = 3; break;
>  	default:
> -		dev_err(dev, "fan_div value %ld not supported."
> +		dev_err(dev, "fan_div value %ld not supported. "
>  		        "Choose one of 1, 2, 4 or 8!\n", val);
>  		mutex_unlock(&data->update_lock);
>  		return -EINVAL;
> -- 
> 1.5.3.5.652.gf192c

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

