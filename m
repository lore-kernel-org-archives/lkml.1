Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZCEPvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZCEPvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZCEPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:51:15 -0500
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:50932 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751187AbZCEPvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:51:14 -0500
Message-ID: <49AFF4EA.6000504@teltonika.lt>
Date: Thu, 05 Mar 2009 17:51:06 +0200
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Darius <augulis.darius@gmail.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MX1 fix include
References: <gkfn87$uo4$1@ger.gmane.org>	<20090113100333.GC11228@pengutronix.de> <499ACF91.1070003@gmail.com>
In-Reply-To: <499ACF91.1070003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius wrote:
> Sascha Hauer wrote:
>> On Mon, Jan 12, 2009 at 04:22:57PM +0200, Darius wrote:
>>> From: Darius Augulis <augulis.darius@gmail.com>
>>>
>>> Includes missed irqs.h in devices.c and mx1ads.c.
>> Looks good, thanks.
> 
> Hi Sascha,
> 
> probably you forgot to merge this in next rc (2), please do this ASAP in next rc, if possible.

Hi Sasha,

Will you submit this patch upstream?
It is definitely 2.6.29 material since it is not possible to compile MX1 without it!

Paulius Zaleckas

> BR,
> Darius
> 
>> BTW do you plan to integrate the missing pieces from arch-imx into
>> arch-mx1, like SDHC and framebuffer? I think we should add these before
>> removing arch-imx.
>>
>> Sascha
>>
>>> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
>>>
>>> Index: linux-2.6.29-rc1/arch/arm/mach-mx1/devices.c
>>> ===================================================================
>>> --- linux-2.6.29-rc1.orig/arch/arm/mach-mx1/devices.c
>>> +++ linux-2.6.29-rc1/arch/arm/mach-mx1/devices.c
>>> @@ -23,6 +23,8 @@
>>>  #include <linux/init.h>
>>>  #include <linux/platform_device.h>
>>>  #include <linux/gpio.h>
>>> +
>>> +#include <mach/irqs.h>
>>>  #include <mach/hardware.h>
>>>  
>>>  static struct resource imx_csi_resources[] = {
>>> Index: linux-2.6.29-rc1/arch/arm/mach-mx1/mx1ads.c
>>> ===================================================================
>>> --- linux-2.6.29-rc1.orig/arch/arm/mach-mx1/mx1ads.c
>>> +++ linux-2.6.29-rc1/arch/arm/mach-mx1/mx1ads.c
>>> @@ -21,6 +21,7 @@
>>>  #include <asm/mach/arch.h>
>>>  #include <asm/mach/time.h>
>>>  
>>> +#include <mach/irqs.h>
>>>  #include <mach/hardware.h>
>>>  #include <mach/common.h>
>>>  #include <mach/imx-uart.h>
>>> -------------------------------------------------------------------
>>> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
>>> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
>>> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>>>
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
> 
