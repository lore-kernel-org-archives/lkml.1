Return-Path: <linux-kernel-owner+w=401wt.eu-S934071AbXG1HJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbXG1HJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 03:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbXG1HJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 03:09:10 -0400
Received: from alpha.lp.pl ([194.1.144.4]:52428 "EHLO alpha.polcom.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756584AbXG1HJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 03:09:09 -0400
Date: Sat, 28 Jul 2007 09:09:06 +0200 (CEST)
From: Grzegorz Kulewski <kangur@polcom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kasper Sandberg <lkml@metanurb.dk>, CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <1185588279.1654.1.camel@localhost> <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Linus Torvalds wrote:
> On Sat, 28 Jul 2007, Kasper Sandberg wrote:
>>
>> Im still not so keen about this, Ingo never did get CFS to match SD in
>> smoothness for 3d applications, where my test subjects are quake(s),
>> world of warcraft via wine, unreal tournament 2004. And this is despite
>> many patches he sent me to try and tweak it.
>
> You realize that different people get different behaviour, don't you?
> Maybe not.
>
> People who think SD was "perfect" were simply ignoring reality. Sadly,
> that seemed to include Con too, which was one of the main reasons that I
> never ended entertaining the notion of merging SD for very long at all:
> Con ended up arguing against people who reported problems, rather than
> trying to work with them.

I don't really want to keep all that -ck flamewar going but this sum-up is 
a little strange for me:

If Con was thinking SD was "perfect" why he released 30+ versions of it? 
And who knows how many versions of his previous scheduler?

Besides Con always tried to help people and improve his code if some bugs 
or problems were reported. Archives of this list prove that. I reported 
several problems (on list and privately) and all were fixed very fast and 
with very kind responses. I had run -ck for months and years and it was 
always very stable (I remember one broken "stable" version).

I don't know what exactly are you refering to when you say about those 
unaddressed reports but maybe it depends on who was asking, how and to do 
what (for example - purely theoretical one, I don't remember exact emails 
you refering to so I am not saying it happened - stating at the beginning 
that the whole design is unacceptable and interactivity hacks are a 
must-have won't make a friend from any maintainer and for sure lowers his 
desire to get anything fixed for that guy). Or maybe Con had some bad day 
or was depressed. Happens. But I really don't remember Con ignoring too 
many valuable user reports in last 3 years...

And no - I am not thinking that SD was "perfect". Nothing is perfect, 
especially not software. But it was based on months and years of Con's
experience with desktop and gaming workloads and extensively tested in 
similar uses by _many_ others. In nearly all possible desktop 
configurations, with most games and all video drivers. This is why it was 
perfectly designed and tuned for such workloads while still being general 
enough and without any ugly hacks. And because of these tests and Con's 
believe that the desktop is very (most?) important all bugs and problems 
in this area were probably killed long ago. I think even design was 
changed and tuned a little at the early stages to help solve such 
interactivity/dekstop/gaming problems.

So it does not surprise me that CFS is worse in such workloads (at least 
for some people) because I strongly suspect that the number of people who 
played games with current version of CFS is limited to about 5, maybe 10. 
And I also suspect that you (and Ingo) will get many regression reports 
when 2.6.23 is released (and months later too... or maybe you won't 
because users will be to "scared" to report such hard to mensure and 
reproduce "unimportant" bugs). Hopefully such problems when reported will 
be addressed as soon as they can. And hopefully they will be easy enough 
to solve without rewriting or redesigning CFS and causing that way even 
more regressions in other areas. If not people will probably be patching 
O(1) scheduler back privately...


Thanks,

Grzegorz Kulewski

