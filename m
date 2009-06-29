Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZF2Krd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZF2Krd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZF2KrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:47:25 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:34143 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZF2KrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WxbFDPQJ0gn+EQVqw/6K1+5LCsx6Yh3yrgcOLwW+SnJiNOtVRy+mZWaJevYzkCQXeS
         xwKTMNot+OV4wqfiBxQDgvEcl5iNyjwFCQX5CLba45vk3F1nHK2o48J99aujvHsST13h
         SFK/6N0dRm5tZWpKb6BpHC9P3sdKQPuU6BPsM=
MIME-Version: 1.0
In-Reply-To: <20090626113059.4c0c2fb3@hyperion.delvare>
References: <4A448926.1030701@samsung.com>
	 <20090626113059.4c0c2fb3@hyperion.delvare>
Date: Mon, 29 Jun 2009 19:47:26 +0900
Message-ID: <1f3430fb0906290347r92201acpb35087c55049d8c5@mail.gmail.com>
Subject: Re: [PATCH] hwmon: add GP2A002 proximity/ambient sensor
From: Minkyu Kang <promsoft@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org, lm-sensors@lm-sensors.org,
       suchang.woo@samsung.com, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

2009/6/26 Jean Delvare <khali@linux-fr.org>:
> On Fri, 26 Jun 2009 17:39:02 +0900, Minkyu Kang wrote:
>> The GP2A002 is a I2C interfaced Sensor for Proximity/Ambient
>> This patch adds support the GP2A002 sensor
>>
>> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
>> Signed-off-by: Suchang Woo <suchang.woo@samsung.com>
>> ---
>>  drivers/hwmon/Kconfig    |    7 +
>>  drivers/hwmon/Makefile   |    1 +
>>  drivers/hwmon/gp2ap002.c |  471 ++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/gp2ap002.h |   21 ++
>>  4 files changed, 500 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/hwmon/gp2ap002.c
>>  create mode 100644 include/linux/gp2ap002.h
>>
>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>> index 2d50166..cc4e200 100644
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -1017,6 +1017,13 @@ config SENSORS_APPLESMC
>>         Say Y here if you have an applicable laptop and want to experience
>>         the awesome power of applesmc.
>>
>> +config SENSORS_GP2AP002
>> +     tristate "GP2AP002 series Proximity/Ambient Sensor"
>> +     depends on HWMON && I2C
>> +     help
>> +       This driver provides support for Proximity/Ambient Sensor.
>> +
>
> This doesn't have anything to do with hardware monitoring, so this
> doesn't belong to drivers/hwmon.
>

Can you please explain about belong to hardware monitoring?
did i missing something?

many thanks :)

-- 
from. prom.
www.promsoft.net
