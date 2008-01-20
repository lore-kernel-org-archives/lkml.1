Return-Path: <linux-kernel-owner+w=401wt.eu-S1759083AbYATFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083AbYATFdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYATFdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:33:05 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:42144 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYATFdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:33:04 -0500
Message-ID: <4792DD22.4070902@davidnewall.com>
Date: Sun, 20 Jan 2008 16:03:22 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org>
In-Reply-To: <20080120051822.GB19784@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Jan 20, 2008 at 03:16:25PM +1030, David Newall wrote:
>   
>> Andi Kleen wrote:
>>     
>>> On Sun, Jan 20, 2008 at 12:57:29PM +1030, David Newall wrote:
>>>   
>>>       
>>>> compatibility.  This is a sleeping giant for Linux.  There are plenty of
>>>>     
>>>>         
>>> Interesting choice of words.
>>>   
>>>       
>> KFC and Dominoes use SCO for their cash registers, to pick just two
>> enormous future opportunities.
>>     
>
> I suppose if they update their cash registers they will just go 
> with fully Linux binaries.
>   

It's not necessarily that simple.  It might be for KFC and Dominoes, but
for others, SCO is not the complete story.  Many legacy systems are
written in COBOL, and must pay a per-seat licence for that on top of the
per-seat licence for UNIX.  It is these systems that are most attracted
towards SCO compatibility.

>>> But it does not make sense for all Linux kernels to always check for iBCS executables
>>> when they don't have to code to run them anyways.
>>>   
>>>       
>> I don't suppose you're suggesting this will make a big difference.  Even
>> if every exec did nothing but immediately exit, it still wouldn't make
>> much difference.
>>     
>
> It's not a big difference, but why do unnecessary work on all 
> Linux kernels? There are a lot of Linux machines out there and 
> if all of them only do a little unnecessary work each fork()
> over a year it adds up to really a lot of wasted cycles.
>   

It still adds up to something that nobody can perceive, not even using a
very fine stopwatch and counting over a period of years.

> Especially since the few people who might really
> need it can easily readd it.
>   
No.  Very few people can add it, easily or otherwise.  Perhaps KFC could
employ somebody to add it, but they'd more likely be able to convert
their entire software stack instead.  The paint shops and mechanics of
the world would have little chance of that.

> But Linux is not good for this currently, at least not unless you
> add a significant patch (which I'm not sure does even exist
> for modern 2.6; iBCS was mainly deployed on 2.4 kernels). And when you 
> add that patch you can easily readd the strcmps too.
>   

Yes, I agree.  Neither side of this issue is of great moment.  On the
one hand we have something that's half-baked at best; on the other hand
we want to remove it for non perceivable gain or benefit.

>> simplification of the story, I know, but still hits the plot highlights.
>>     
>
> You're worried about this patch generating headlines?

No, I don't see this as headline making material.  The existing code,
though, is a rough spot in the kernel.  So long as it's there, somebody
will feel the need to scratch it, as you do.  Absent the choice of
removing the code, and the only way left to scratch is to complete it. 
Remove the code and there's nothing there that itches, which is a bad
thing in this case.
