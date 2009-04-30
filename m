Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbZD3RBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbZD3RBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbZD3RBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:01:14 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:46424 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZD3RBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:01:13 -0400
Date: Thu, 30 Apr 2009 19:01:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] asus_atk0110: fix compiler warning
Message-ID: <20090430190101.7a46f082@hyperion.delvare>
In-Reply-To: <20090429192255.GA8623@dreamland.darkstar.lan>
References: <20090429192255.GA8623@dreamland.darkstar.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On Wed, 29 Apr 2009 21:22:55 +0200, Luca Tettamanti wrote:
> atk_sensor_type is only used when DEBUG is defined.
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> 
> ---
> Jean can you pick this up?
> 
>  drivers/hwmon/asus_atk0110.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
> index 0897ede..bff0103 100644
> --- a/drivers/hwmon/asus_atk0110.c
> +++ b/drivers/hwmon/asus_atk0110.c
> @@ -348,6 +348,7 @@ static int validate_hwmon_pack(struct atk_data *data, union acpi_object *obj)
>  	return 0;
>  }
>  
> +#ifdef DEBUG
>  static char const *atk_sensor_type(union acpi_object *flags)
>  {
>  	u64 type = flags->integer.value & ATK_TYPE_MASK;
> @@ -370,6 +371,7 @@ static char const *atk_sensor_type(union acpi_object *flags)
>  
>  	return what;
>  }
> +#endif
>  
>  static void atk_print_sensor(struct atk_data *data, union acpi_object *obj)
>  {

Thanks for the fix, I've just applied it.

-- 
Jean Delvare
