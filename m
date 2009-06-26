Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZFZJbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZFZJbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZFZJbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:31:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42064 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZFZJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:31:05 -0400
Date: Fri, 26 Jun 2009 11:30:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       lm-sensors@lm-sensors.org, suchang.woo@samsung.com,
       kyungmin.park@samsung.com
Subject: Re: [PATCH] hwmon: add GP2A002 proximity/ambient sensor
Message-ID: <20090626113059.4c0c2fb3@hyperion.delvare>
In-Reply-To: <4A448926.1030701@samsung.com>
References: <4A448926.1030701@samsung.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 17:39:02 +0900, Minkyu Kang wrote:
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
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 2d50166..cc4e200 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1017,6 +1017,13 @@ config SENSORS_APPLESMC
>  	  Say Y here if you have an applicable laptop and want to experience
>  	  the awesome power of applesmc.
>  
> +config SENSORS_GP2AP002
> +	tristate "GP2AP002 series Proximity/Ambient Sensor"
> +	depends on HWMON && I2C
> +	help
> +	  This driver provides support for Proximity/Ambient Sensor.
> +

This doesn't have anything to do with hardware monitoring, so this
doesn't belong to drivers/hwmon.

-- 
Jean Delvare
