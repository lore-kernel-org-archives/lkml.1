Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXKUSiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXKUSiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbXKUShu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:37:50 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:60385 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855AbXKUSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:37:49 -0500
Date: Wed, 21 Nov 2007 19:37:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 15/59] drivers/hwmon: Add missing "space"
Message-ID: <20071121193745.00f31f21@hyperion.delvare>
In-Reply-To: <1195523331-15303-16-git-send-email-joe@perches.com>
References: <1195523331-15303-1-git-send-email-joe@perches.com>
	<1195523331-15303-2-git-send-email-joe@perches.com>
	<1195523331-15303-3-git-send-email-joe@perches.com>
	<1195523331-15303-4-git-send-email-joe@perches.com>
	<1195523331-15303-5-git-send-email-joe@perches.com>
	<1195523331-15303-6-git-send-email-joe@perches.com>
	<1195523331-15303-7-git-send-email-joe@perches.com>
	<1195523331-15303-8-git-send-email-joe@perches.com>
	<1195523331-15303-9-git-send-email-joe@perches.com>
	<1195523331-15303-10-git-send-email-joe@perches.com>
	<1195523331-15303-11-git-send-email-joe@perches.com>
	<1195523331-15303-12-git-send-email-joe@perches.com>
	<1195523331-15303-13-git-send-email-joe@perches.com>
	<1195523331-15303-14-git-send-email-joe@perches.com>
	<1195523331-15303-15-git-send-email-joe@perches.com>
	<1195523331-15303-16-git-send-email-joe@perches.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, 19 Nov 2007 17:48:07 -0800, Joe Perches wrote:
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

Obviously correct, thanks.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
