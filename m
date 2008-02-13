Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYBMNV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYBMNV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYBMNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:21:21 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:24943 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYBMNVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:21:21 -0500
Date: Wed, 13 Feb 2008 08:17:55 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (adm1026) Properly terminate sysfs groups (Was:
	panic about sysfs with adm1026)
Message-ID: <20080213131755.GG1154@jupiter.solarsys.private>
References: <86802c440802092355l7393fe07gfbd021e9cef66181@mail.gmail.com> <20080210171004.GB25353@kroah.com> <20080210190115.2ebd4124@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210190115.2ebd4124@hyperion.delvare>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean et. al.:

* Jean Delvare <khali@linux-fr.org> [2008-02-10 19:01:15 +0100]:
> The missing NULL at the end of two sysfs file groups causes a kernel
> crash when calling sysfs_create_group().
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/hwmon/adm1026.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-2.6.25-rc0.orig/drivers/hwmon/adm1026.c	2008-02-10 11:21:54.000000000 +0100
> +++ linux-2.6.25-rc0/drivers/hwmon/adm1026.c	2008-02-10 18:51:00.000000000 +0100
> @@ -1624,6 +1624,7 @@ static struct attribute *adm1026_attribu
>  	&dev_attr_temp3_crit_enable.attr,
>  	&dev_attr_temp3_auto_point1_pwm.attr,
>  	&dev_attr_temp3_auto_point2_pwm.attr,
> +	NULL
>  };
>  
>  static const struct attribute_group adm1026_group_temp3 = {
> @@ -1639,6 +1640,7 @@ static struct attribute *adm1026_attribu
>  	&sensor_dev_attr_in9_max.dev_attr.attr,
>  	&sensor_dev_attr_in9_min.dev_attr.attr,
>  	&sensor_dev_attr_in9_alarm.dev_attr.attr,
> +	NULL
>  };
>  
>  static const struct attribute_group adm1026_group_in8_9 = {

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

