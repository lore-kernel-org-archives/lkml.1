Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbYEGWEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbYEGWEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763014AbYEGWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:04:13 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:42039 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762063AbYEGWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:04:08 -0400
Message-ID: <48222784.10506@keyaccess.nl>
Date: Thu, 08 May 2008 00:04:52 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805072315360.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-05-08 23:41, Thomas Gleixner wrote:

>>> Clearing it in the cpuinfo is just a cosmetic side effect which does
>>> no harm at all.
>> Oh yes, it does. It makes people unaware that their CPUs _should_ be
>> supporting PAT. The thing's not called /proc/kernelinfo for a reason.
> 
> it's named /proc/cpuinfo

Exactly.

> and this unawareness of the until now not utilized PAT feature is the
> least of our worries vs. PAT

It's _my_ worry. I-the-user don't want my cpuinfo lying to me just
because if fits your-the-developer's codeflow better. Sheer insanity.

Getting philosophical tends to be a bad idea here but like always and
in this case; if you hide the world from people you disallow them from
improving it. It's that I _knew_ that my CPU should be supporting PAT
so that I could complain about it, but I'm your average LKML dwelling
datasheet collector.

Your feature may be very important and groovy to you, but to me it's
much more important that my cpuinfo doesn't lie to me. Please make it
not lie to me.

>>>> And this patch (by the author of the code himself) is the first time where
>>>> it breaks.
>>> Very interesting analysis. What broke ? This CPU was never in the set
>>> of supported ones at all.
>> You misunderstood. Yinghai's patch only changed one of the code sites
>> and not the others, which (if I understood right) is the breakage
>> Adrian was reffering to.
> 
> I know exactly what he was referring to. So what's the problem ?
> 
> Yinghai missed to add it to the other place and he is hardly to blame
> for that. This code is messy and thats not his fault.

What on earth? Yes, it is. He added that code. The only thing that this complaint
is about is that his fix-patch added the family 6, model 7 to only _one_ instance
of that code that he himself added and not all three.

>> And would yelling at people how shuffle in code without (publicly at
>> least) addressing one of your fellow arch maintainers objections
> 
> 1) hpa asked a question http://lkml.org/lkml/2008/3/25/118
> 2) his question was answered http://lkml.org/lkml/2008/3/25/292
> 3) hpa did not object (no lkml ref, because there is none)
> 
> So what's your point ? Throwing factoids into a discussion is
> not really helpful.

And HPA (and Molnar) then said in response to that answer:

http://lkml.org/lkml/2008/3/25/322

It's right there in response to your own link. It seems you originally missed
it, but how did you manage this time again?
 
>> and Pavel's review comments about code duplication without a single
>> line of explanation/changelog do?
> 
> As I said before. The changelog is useless and Adrians point about
> that is completely correct. 

Pavel was full of it? 

Rene.
