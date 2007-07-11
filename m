Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbXGKWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbXGKWz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765083AbXGKWzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:55:13 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:45515 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761589AbXGKWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:55:11 -0400
Message-ID: <46955F4D.3090206@monkeh.net>
Date: Wed, 11 Jul 2007 22:53:01 +0000
From: Alex Maclean <monkeh@monkeh.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Tim Gardner <tim.gardner@canonical.com>
Subject: Re: acpi regression on some laptops
References: <20070710160056.443ae9ae@i1501.lan.towertech.it>	<46952CC5.6050800@redhat.com> <20070712000124.22d0c3a7@i1501.lan.towertech.it>
In-Reply-To: <20070712000124.22d0c3a7@i1501.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Wed, 11 Jul 2007 15:17:25 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
>>>  I'm trying to debug it.. any help/pointers are appreciated. I dont't
>>>  have a deep knowledge of the subsystems involved.
>> What options did you try?
>>
>>   nohpet
>>   nohz=off
>>   highres=off
>>
>> Should be tried in various combinations.
> 
>  Hi,
> 
>    I tried all the permutations of the above with the same result:
>  the kernel hangs at NET: Registering protocol family 2.
> 
>  With nolapic it hangs at APIC: Using PIC for interrupt routing
> 
>  With acpi=off it boots but, obviously, everything acpi related
>  does not work.
>  
>  anything else I can try? The laptop does not have a serial port,
>  so I can't capture the dmesg output.
> 

I'm unsure just what hardware you're working with, but try using the 
option nolapic_timer.
