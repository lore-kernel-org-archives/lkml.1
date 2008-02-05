Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYBEEo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYBEEo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYBEEoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:44:18 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:44265 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYBEEoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:44:17 -0500
Date: Mon, 04 Feb 2008 23:44:04 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
In-reply-to: <47A763D4.5090606@rtr.ca>
To: Mark Lord <liml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Chris Rankin <rankincj@yahoo.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200802042344.04956.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <745427.71265.qm@web52907.mail.re2.yahoo.com>
 <200802030125.24663.gene.heskett@gmail.com> <47A763D4.5090606@rtr.ca>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008, Mark Lord wrote:
>Gene Heskett wrote:
>> On Sunday 03 February 2008, Ingo Molnar wrote:
>>> * Gene Heskett <gene.heskett@gmail.com> wrote:
>>>> I believe its the same, but lemme paste it for sure, yes:
>>>> [   26.339926] ENABLING IO-APIC IRQs
>>>> [   26.340119] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
>>>> [   26.350129] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>>>> [   26.350182] ...trying to set up timer (IRQ0) through the 8259A ...
>>>> failed. [   26.350185] ...trying to set up timer as Virtual Wire IRQ...
>>>> failed. [   26.360186] ...trying to set up timer as ExtINT IRQ... works.
>>>>
>>>> The third line is the only line that makes it to the screen during the
>>>> boot trace.
>>>>
>>>> Now, what does this tell us?
>>>
>>> the question would be:
>>>
>>> - if you remove the acpi_use_timer_override boot flag
>>> - and if you boot a kernel with this hack applied
>>>
>>> => do those weird PATA failures come back?
>>>
>>> If the failues do _not_ come back then the problem is somehow
>>> affected/worked-around by the IO-APIC code that generates the above 4
>>> lines. If the failures are still the same then the above 4 lines are
>>> really just an uninteresting side-effect of the acpi_use_timer_override
>>> flag - and the real side-effects (that fixes PATA on your box) are to be
>>> found elsewhere.
>>>
>>> Sadly, the latter variant is the expected answer.
>>>
>>> 	Ingo
>>
>> And at this point, I can't tell.  This reboot was from a cold start,
>> without the argument, and cold by long enough to make the rounds about the
>> house and pick up a beer, but not take my evening pillbox.  A minute cold,
>> maybe 2 max. The log is clean since except for a kudzu nag of some sort:
>
>..
>
>Just to muddy your observations:  it is quite possible that a cold
> (power-off) reboot may be required to properly observe what happens here.
>
Precisely why I've now done that twice, without using the extra argument.  No 
recurrence dammit.

>Cheers



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
He who makes a beast of himself gets rid of the pain of being a man.
		-- Dr. Johnson
