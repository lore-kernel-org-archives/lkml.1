Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXKSLJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXKSLJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 06:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXKSLJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 06:09:27 -0500
Received: from hu-out-0506.google.com ([72.14.214.237]:30695 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbXKSLJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 06:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jBLdBorN415exuokJroAV1xw7U1INX/4v3xqHPWaRinjOGcMwWzTkoHrcctVH2nWnJqmizAY84l8VEbmcirXJjrqU5NxWNC30xUXd8ikixy+sz9r6D8q0cPZv4kwFDkJrvpcXYYPeSnbpM8rlm7bqWdgJvUlwIiYIeLejixREbc=
Message-ID: <47416EFF.3070402@gmail.com>
Date: Mon, 19 Nov 2007 14:09:51 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, astarikovskiy@suse.de,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix segfault when printing battery status
References: <200711182049.33355.eike-kernel@sf-tec.de> <47415B46.4020709@gmail.com> <200711191129.35144.eike-kernel@sf-tec.de>
In-Reply-To: <200711191129.35144.eike-kernel@sf-tec.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rolf Eike Beer wrote:
> Alexey Starikovskiy wrote:
>   
>> Rolf Eike Beer wrote:
>>     
>>> cat
>>> /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:19/PNP0C0A:00/power_
>>> supply/BAT1/status
>>>
>>> This leads to a stacktrace as acpi_battery_get_property() returns 0 for a
>>> case where it does not set val->intval. These value is used as an array
>>> index in
>>> drivers/power/power_supply_sysfs.c::power_supply_show_property(). I had a
>>> situation where the value was 4096 which caused a problem as the array
>>> only has 5 entries.
>>>
>>> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
>>>       
>> Rolf, thanks for remainding.
>>     
>
> Huh? This one is unrelated to the problem I reported two weeks ago...
>
> Eike
>   
You are second to send the same patch, first one I already acked.
But it seems that Len did not pick it up yet.
Look for "ACPI: Always return valid 'status' from 
acpi_battery_get_property()"
if interested...

Regards,
Alex.

