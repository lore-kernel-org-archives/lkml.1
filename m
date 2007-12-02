Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXLBPAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXLBPAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbXLBO77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 09:59:59 -0500
Received: from rtr.ca ([76.10.145.34]:1383 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbXLBO76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 09:59:58 -0500
Message-ID: <4752C86D.8050909@rtr.ca>
Date: Sun, 02 Dec 2007 09:59:57 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 20000+ wake-ups/second in 2.6.24.   Bug?
References: <924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com> <20071130142058.816d1693.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com> <4750CC78.9070105@rtr.ca> <20071130190227.1976e682@laptopd505.fenrus.org> <4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <4750D899.4020905@rtr.ca> <4751F1AB.2060801@rtr.ca> <20071202144113.GJ15974@stusta.de>
In-Reply-To: <20071202144113.GJ15974@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Dec 01, 2007 at 06:43:39PM -0500, Mark Lord wrote:
>> Mark Lord wrote:
>>> Arjan van de Ven wrote:
>>>> On Fri, 30 Nov 2007 22:31:17 -0500
>>>> Mark Lord <lkml@rtr.ca> wrote:
>> ...
>>>>> Speaking of which.. what's with powertop on 2.6.24 ???
>>>>> It's gone from 100-200 wakeups/sec to 20000 wakeups/sec !!!!!!!
>>>> ho hum.. Lenovo T61?
>>>> I have some reports that that happens once in a while (but it's not
>>>> limited to .24 and it's also real, it's not a powertop bug but it
>>>> actually is waking up that much)..
>>> ..
>>>
>>> No, it's my hefty Dell Inspiron 9400.
>>>
>>> And I just figured out the powertop:  it needed the kernel timers
>>> patch from the powertop site that was originally for 2.6.21..
>> ...
>>
>> Dagnabbit.. it's done it again.. went from 100-200 wakeups/sec
>> back up to 20000+ wakeups/sec.  This time *with* the powertop patches in place.
> 
> What is the status with an unpatched 2.6.23?
..

More wakeups than without patching, but still on the order of hundreds
of wakeups/sec; nowhere near the 20000+ wakeups/sec range when it goes wonky.

> Please send the output of "dmesg -s 1000000" for both 2.6.23 and 2.6.24.
..

Okay, I'll do a couple of reboots and collect that info for private email,
and maybe post a diff of the two here.

Cheers
