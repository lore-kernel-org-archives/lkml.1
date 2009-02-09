Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZBIJo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZBIJo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZBIJoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:44:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50954 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZBIJoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:44:17 -0500
Date: Mon, 9 Feb 2009 10:44:16 +0100
From: Pavel Machek <pavel@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
Message-ID: <20090209094416.GB4358@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add support for HP Pavlion dv5 models, whose sensor has an inverted x
> axis.
> 
> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
> ---
> My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
> patch marks the inversion for all the dv5. I can include the full
> dmidecode output if this is deemed necessary.
> 
> With the laptop standing still on my desk jstest reports X and Y values
> fluctuating from -8k to +8k (more or less). I assume this is normal?

Well, on hp2140 it fluctuates 1000+-500 or so... But Z axis is still
significantly different.

How much is 7 while in "steady state" for you?
								Pavel

>  drivers/hwmon/hp_accel.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> index abf4dfc..5a379bd 100644
> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -179,6 +179,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
>  	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
>  	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
>  	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
> +	AXIS_DMI_MATCH("HPDV5", "HP Pavilion dv5", x_inverted),
>  	{ NULL, }
>  /* Laptop models without axis info (yet):
>   * "NC6910" "HP Compaq 6910"

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
