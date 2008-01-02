Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYABQS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYABQS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 11:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYABQSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 11:18:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:26225 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbYABQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 11:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=b2/AYMdKDeP5B/mqRRwetL/+CwhEVPNXzQSJGqjH08DroiwGQn94uUMjfdVLnnr3wWrUn0j0nsvGnPKbFohGqPb+67zLgOFEbLYJqMLUx7og3VJlVGb+DVP5S9JkK2AVqvqxENtP4Ws3fZXiV8l/fBliueaHEvnP9VEED1Eyl6Q=
Message-ID: <477BB959.1040207@gmail.com>
Date: Wed, 02 Jan 2008 19:18:33 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: hal@lists.freedesktop.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: kpowersave stuck at battery charging
References: <200801021248.55844.arvidjaar@mail.ru> <477B6AA5.5020803@gmail.com> <200801021610.45582.arvidjaar@mail.ru>
In-Reply-To: <200801021610.45582.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Wednesday 02 January 2008, Alexey Starikovskiy wrote:
>   
>> Andrey Borzenkov wrote:
>>     
>>> This is did not happen before; I am not sure right now what caused this 
>>>       
> (i.e. 
>   
>>> battery aging or some software change) nor whether this is 
>>>       
> kernel/HAL/kpowersave 
>   
>>> issue.
>>>
>>> kpowersave is stuck at assuming battery is loading and at 94%. Sysfs 
>>>       
> displays 
>   
>>> battery state as Full:
>>>
>>>   
>>>       
>> Frequent battery charging shortens lifetime of the battery, so some (may 
>> be all now)
>> notebook manufacturers do not start charging  battery until it discharge 
>> to some degree (~90%).
>>     
>
> I thought Li-Ion batteries do not have memory effect. Actually I remember to 
> have read recommendation to avoid deep discharges of Li-Ion battery, it was 
> adviced to charge it as often as possible.
>   
IBM has advice to not re-charge battery until it discharged to 95%.
It was implemented in their batteries/notebooks.
There is no memory effect in Li-Ion batteries, there is only limited 
number of
charge cycles -- about 1000 times, thus "as often as possible" is advice
of the battery seller :)
>   
>> It could be your case. Please try to discharge battery to, say, 89% and 
>> then check if it charges to the
>> 100%.
>>     
>
> That is exactly the question - how do you compute 100%? As far as I can tell the 
> only possibility is - when battery stops charging. At this point you have to 
> assume battery is fully charged.
>   
Last charge would be good reference. Think of the battery as constantly
degrading resource.
> I tried to discharge battery (it was around 78%) and plug AC in again. It went 
> on Charging until the same limit after that state changed to Full (well, in case 
> of ACPI battery we really only can state - not (dis-)charging, there is no 
> special Full state flag); kpowersave still believes battery is not fully 
> charged. Main interface shows 84% (no Charging) - tooltip states it is being 
> charged.
>
>   
So, that is the state of your battery. If you buy new one, it will go 
high again.

Regards,
Alex.
