Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXLBPMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXLBPMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXLBPMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:12:40 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49310 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753503AbXLBPMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:12:39 -0500
Date: Sun, 2 Dec 2007 16:12:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 20000+ wake-ups/second in 2.6.24.   Bug?
Message-ID: <20071202151231.GK15974@stusta.de>
References: <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com> <4750CC78.9070105@rtr.ca> <20071130190227.1976e682@laptopd505.fenrus.org> <4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <4750D899.4020905@rtr.ca> <4751F1AB.2060801@rtr.ca> <20071202144113.GJ15974@stusta.de> <4752C86D.8050909@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4752C86D.8050909@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 09:59:57AM -0500, Mark Lord wrote:
> Adrian Bunk wrote:
>> On Sat, Dec 01, 2007 at 06:43:39PM -0500, Mark Lord wrote:
>>> Mark Lord wrote:
>>>> Arjan van de Ven wrote:
>>>>> On Fri, 30 Nov 2007 22:31:17 -0500
>>>>> Mark Lord <lkml@rtr.ca> wrote:
>>> ...
>>>>>> Speaking of which.. what's with powertop on 2.6.24 ???
>>>>>> It's gone from 100-200 wakeups/sec to 20000 wakeups/sec !!!!!!!
>>>>> ho hum.. Lenovo T61?
>>>>> I have some reports that that happens once in a while (but it's not
>>>>> limited to .24 and it's also real, it's not a powertop bug but it
>>>>> actually is waking up that much)..
>>>> ..
>>>>
>>>> No, it's my hefty Dell Inspiron 9400.
>>>>
>>>> And I just figured out the powertop:  it needed the kernel timers
>>>> patch from the powertop site that was originally for 2.6.21..
>>> ...
>>>
>>> Dagnabbit.. it's done it again.. went from 100-200 wakeups/sec
>>> back up to 20000+ wakeups/sec.  This time *with* the powertop patches in place.
>>
>> What is the status with an unpatched 2.6.23?
> ..
>
> More wakeups than without patching, but still on the order of hundreds
> of wakeups/sec; nowhere near the 20000+ wakeups/sec range when it goes wonky.

OK.

>> Please send the output of "dmesg -s 1000000" for both 2.6.23 and 2.6.24.
> ..
>
> Okay, I'll do a couple of reboots and collect that info for private email,
> and maybe post a diff of the two here.

Thanks for doing this.

But please send the dmesg output to the list - it's better when everyone 
who looks at this thread also sees all information.

> Cheers

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

