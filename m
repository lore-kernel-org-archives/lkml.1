Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZLNCfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZLNCfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 21:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZLNCfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 21:35:12 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33160 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZLNCfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 21:35:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Sd+tcPaIj3GQLCerKWpS9MI2zZiuPKUiADXUqu2jv1t1wvkq2KfjDK7ahJJxOSdwRN
         b6KvBdQzzlny8lf2HdwnzsX2m580G55aCrHFGJQWcMVCHM9mWxKYYJg1HV0f0GpNjxPp
         +n55MRTXVgIb6xP5hx9Tp/6rmfxkUaItNmG9w=
Message-ID: <4B25A474.4020305@gmail.com>
Date: Sun, 13 Dec 2009 18:35:32 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a typo in drivers/acpi/battery.c
References: <1260744536-20762-1-git-send-email-justinmattock@gmail.com>	<1260744536-20762-2-git-send-email-justinmattock@gmail.com>	<20091213151545.4ac17532.rdunlap@xenotime.net>	<4B258576.3070508@gmail.com> <20091213172129.02fe156c.rdunlap@xenotime.net>
In-Reply-To: <20091213172129.02fe156c.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/09 17:21, Randy Dunlap wrote:
> On Sun, 13 Dec 2009 16:23:18 -0800 Justin P. Mattock wrote:
>
>> On 12/13/09 15:15, Randy Dunlap wrote:
>>> On Sun, 13 Dec 2009 14:48:56 -0800 Justin P. Mattock wrote:
>>>
>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>> ---
>>>>    drivers/acpi/battery.c |    2 +-
>>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
>>>> index 3f4602b..cada73f 100644
>>>> --- a/drivers/acpi/battery.c
>>>> +++ b/drivers/acpi/battery.c
>>>> @@ -831,7 +831,7 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
>>>>    					dev_name(&device->dev), event,
>>>>    					acpi_battery_present(battery));
>>>>    #ifdef CONFIG_ACPI_SYSFS_POWER
>>>> -	/* acpi_batter_update could remove power_supply object */
>>>> +	/* acpi_battery_update could remove power_supply object */
>>>>    	if (battery->bat.dev)
>>>>    		kobject_uevent(&battery->bat.dev->kobj, KOBJ_CHANGE);
>>>>    #endif
>>>> --
>>>
>>> Hi,
>>>
>>> You don't need an intro patch email and then the patch email
>>> for such a simple patch.
>>>
>>> Also, please note (from "MAINTAINERS" or from scripts/get_maintainer.pl)
>>> that acpi patches go to linux-acpi@vger.kernel.org .
>>>
>>> ---
>>> ~Randy
>>>
>>
>> So should I resend this to acpi then, or just
>> take note of this the next time?
>
> I'd say resend to linux-acpi and cc: the acpi maintainer.
>
> ---
> ~Randy
>

there you have it.
cc'd len brown
(not sure who the acpi maintainers are)

Justin P. Mattock
