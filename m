Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbZFZJTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbZFZJTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZFZJTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:19:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbZFZJTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:19:14 -0400
Subject: Re: [PATCH] hwmon: add GP2A002 proximity/ambient sensor
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       lm-sensors@lm-sensors.org, suchang.woo@samsung.com,
       kyungmin.park@samsung.com
In-Reply-To: <4A448926.1030701@samsung.com>
References: <4A448926.1030701@samsung.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 14:46:00 +0530
Message-Id: <1246007760.3067.5.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 17:39 +0900, Minkyu Kang wrote:
> The GP2A002 is a I2C interfaced Sensor for Proximity/Ambient
> This patch adds support the GP2A002 sensor
> 
> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
> Signed-off-by: Suchang Woo <suchang.woo@samsung.com>
> ---
>  drivers/hwmon/Kconfig    |    7 +
>  drivers/hwmon/Makefile   |    1 +
>  drivers/hwmon/gp2ap002.c |  471 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/gp2ap002.h |   21 ++
>  4 files changed, 500 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/gp2ap002.c
>  create mode 100644 include/linux/gp2ap002.h
> 

> diff --git a/include/linux/gp2ap002.h b/include/linux/gp2ap002.h
> new file mode 100644
> index 0000000..b6a950b
> --- /dev/null
> +++ b/include/linux/gp2ap002.h
> @@ -0,0 +1,21 @@
> +/*
> + *  Copyright (C) 2009 Samsung Electronics
> + *  Minkyu Kang <mk7.kang@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __GP2AP002_H_
> +#define __GP2AP002_H_
> +
> +struct gp2ap002_platform_data {
> +	int (*get_adc)(void);
> +	void (*power_enable)(int);
> +	int vo_gpio;
> +	int prox_mode;
> +	int enable;
> +};
> +
> +#endif

I am curious what is the use of include/linux/gp2ap002.h, it only have
gp2ap002_platform_data structure which you can keep in your source file
the only file which is using it.

Thanks,
--
JSR

