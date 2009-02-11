Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZBKK0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZBKK0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZBKK0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:26:14 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:7632 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZBKK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:26:13 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4992A7C1.7040607@tremplin-utc.net>
Date: Wed, 11 Feb 2009 11:26:09 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: giuseppe.bilotta@gmail.com, palatis@gmail.com, pavel@suse.cz,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch
 removed from -mm tree
References: <200902102347.n1ANlYkI011003@imap1.linux-foundation.org>
In-Reply-To: <200902102347.n1ANlYkI011003@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org schreef:
> The patch titled
>      lis3lv02d: add axes knowledge of HP Pavilion dv5 models
> has been removed from the -mm tree.  Its filename was
>      lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch
> 
> This patch was dropped because an updated version will be merged

Hello Andrew,
With the patch "lis3lv02d: support both one- and two-byte sensors",
Giuseppe has confirmed that this patch is still correct. Would you mind
queuing it back for 2.6.29?

Palatis, if you could try this patch plus the patch "lis3lv02d: support
both one- and two-byte sensors" to confirm it does the right thing also
with your laptop, it would be great. Unfortunately, right now I think
they apply only on top of the -mm tree...

Thanks,
Eric


> ------------------------------------------------------
> Subject: lis3lv02d: add axes knowledge of HP Pavilion dv5 models
> From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
> 
> Add support for HP Pavlion dv5 models, whose sensor has an inverted x
> axis.
> 
> My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
> patch marks the inversion for all the dv5.
> 
> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
> Acked-by: Eric Piel <Eric.Piel@tremplin-utc.net>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Palatis Tseng <palatis@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/hwmon/hp_accel.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models drivers/hwmon/hp_accel.c
> --- a/drivers/hwmon/hp_accel.c~lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models
> +++ a/drivers/hwmon/hp_accel.c
> @@ -179,6 +179,7 @@ static struct dmi_system_id lis3lv02d_dm
>  	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
>  	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
>  	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
> +	AXIS_DMI_MATCH("HPDV5", "HP Pavilion dv5", x_inverted),
>  	{ NULL, }
>  /* Laptop models without axis info (yet):
>   * "NC6910" "HP Compaq 6910"
