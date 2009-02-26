Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZBZVfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZBZVfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZBZVfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:35:45 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:49270 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbZBZVfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:35:45 -0500
Message-ID: <49A70B24.6090706@krogh.cc>
Date: Thu, 26 Feb 2009 22:35:32 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc> <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
In-Reply-To: <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Thu, Feb 26, 2009 at 12:43 PM, Jesper Krogh <jesper@krogh.cc> wrote:
>> Linus Torvalds wrote:
>>> On Thu, 26 Feb 2009, Jesper Krogh wrote:
>>>> 2.6.26.8 doesnt have this problem.
>>>>
>>>> The "current_clocsource" is the same on both systems.
>>>>
>>>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>>>> tsc
>>> What does the frequency calibrate to? It should be in the dmesg. Does it
>>> differ by a big amount?
>> Non-working:
>> $ dmesg | grep -i freq
>> [    0.004007] Calibrating delay loop (skipped), value calculated using
>> timer frequency.. 4620.05 BogoMIPS (lpj=9240104)
>>
>> 2.6.26.8 doesn't have that information.
> 
> I'm surprised the clocksource watchdog isn't catching it.
> 
> What's the output from:
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource

$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc acpi_pm jiffies

Same on both.

> Also mind sending the full dmesg for both kernels?

http://krogh.cc/~jesper/dmesg-2.6.29-rc6.txt
http://krogh.cc/~jesper/dmesg-2.6.26.8.txt

-- 
Jesper

