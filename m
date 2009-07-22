Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZGVGdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZGVGdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZGVGdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:33:37 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:56656 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGVGdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:33:36 -0400
Message-ID: <4A66B2B7.7000407@petalogix.com>
Date: Wed, 22 Jul 2009 08:33:27 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: monstr@monstr.eu, linux-kernel@vger.kernel.org, raph@8d.com,
       dbrownell@users.sourceforge.net, diego.dompe@ridgerun.com,
       rpurdie@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds: gpio-leds: Fix typographics fault
References: <1246515155-23823-1-git-send-email-monstr@monstr.eu> <fa686aa40907020755l16d38a44t1a759d9731fb1022@mail.gmail.com>
In-Reply-To: <fa686aa40907020755l16d38a44t1a759d9731fb1022@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard and Andrew,

can you please handle this patch through your tree? Or through mm tree.

Thanks,
Michal

> On Thu, Jul 2, 2009 at 12:12 AM, <monstr@monstr.eu> wrote:
>   
>> From: Michal Simek <monstr@monstr.eu>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>     
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
>   
>> ---
>>  drivers/leds/leds-gpio.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
>> index 6b06638..107e5ae 100644
>> --- a/drivers/leds/leds-gpio.c
>> +++ b/drivers/leds/leds-gpio.c
>> @@ -80,7 +80,7 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
>>
>>        /* skip leds that aren't available */
>>        if (!gpio_is_valid(template->gpio)) {
>> -               printk(KERN_INFO "Skipping unavilable LED gpio %d (%s)\n",
>> +               printk(KERN_INFO "Skipping unavailable LED gpio %d (%s)\n",
>>                                template->gpio, template->name);
>>                return 0;
>>        }
>> --
>> 1.5.5.1
>>
>>
>>     
>
>
>
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

