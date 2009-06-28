Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZF1TCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZF1TCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZF1TCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:02:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44577 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZF1TCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:02:07 -0400
Date: Sun, 28 Jun 2009 21:01:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 18/62] drivers/hwmon/sht15.c: Remove 
 unnecessary semicolons
Message-ID: <20090628210158.7df366ad@hyperion.delvare>
In-Reply-To: <b74f45f84ee741d41ab6938ea07fed85ee79b0a2.1246173681.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	<b74f45f84ee741d41ab6938ea07fed85ee79b0a2.1246173681.git.joe@perches.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, 28 Jun 2009 09:26:23 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/sht15.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
> index 56cd600..6290a25 100644
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -257,7 +257,7 @@ static inline int sht15_update_single_val(struct sht15_data *data,
>  				 (data->flag == SHT15_READING_NOTHING),
>  				 msecs_to_jiffies(timeout_msecs));
>  	if (ret == 0) {/* timeout occurred */
> -		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));;
> +		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
>  		sht15_connection_reset(data);
>  		return -ETIME;
>  	}

Applied, thanks.

-- 
Jean Delvare
