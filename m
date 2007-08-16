Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbXHPUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbXHPUmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXHPUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:42:45 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:59082 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbXHPUmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:42:44 -0400
Date: Thu, 16 Aug 2007 22:42:42 +0200
Message-Id: <1930295607@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: bunk@stusta.de, pwil3058@bigpond.net.au
Subject: Re: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/c6TBvftt7wSQWUWCJdKwLHwO0MLQL5WXM0/A84WRsMuuWm
 v20kYqsLqsRvPjxA1H56VUa3G7vS9TzYxpBAGduRDyyhzCAK40=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Having a framework for giving people the choice between different 
>solutions usually sounds good in theory, but in practice there's the 
>often underestimated high price of people using a different solution 
>instead of reporting a problem with one solution or people adding 
>features to only one of the solutions resulting in different solutions 
>having different features and bugs instead of one solution with all 
>features and bug fixes.
>
>So you should give a good technical explanation why it's not technically 
>possible or not desirable for one solution to work well for everyone.

>From a user`s point of view, i like PlugSched.

It gives the average or inexperienced user the ability to switch between 
different schedulers and it empowers him to compare between them easily.

I like choice.

Ok, it`s not good to have too much of that, but it`s always good 
to have at least one or two alternatives.

No patch and no compile orgy for the end-user anymore - he can try if 
a different scheduler makes his stuttering audio go away or if his 
desktop-environment is more responsive with "itchysched" than 
with "scratchysched".

Take this as a user`s vote for PlugSched.

There are pluggable I/O schedulers in Linux for years now, there was 
that switch from AS to CFQ as the default - so please give us pluggable 
CPU schedulers, too ! :)

roland

ps:
i trust you kernel developers know what you are doing, but if scares me
a little bit, that some integral and living part like O(1) being ripped off 
and being replaced by something new. 




On Sun, Jul 15, 2007 at 10:47:51AM -0700, Li, Tong N wrote:
> > On Thursday 12 July 2007 00:17, Al Boldi wrote:
> > 
> > > Peter Williams wrote:
> > >>
> > >> Probably the last one now that CFS is in the main line :-(.
> > >
> > > What do you mean?  A pluggable scheduler framework is indispensible
> even
> > in
> > > the presence of CFS or SD.
> > 
> > Indeed, and I hope it gets merged, giving people the chance to test
> out
> > different schedulers easily, without having to do patching,
> de-patching,
> > re-patching and blah blah blah.
> > 
> 
> Yes, such a framework would be invaluable, especially given that
> scheduling often has conflicting goals and different workloads have
> different requirements. No single solution fits all.
>...

Having a framework for giving people the choice between different 
solutions usually sounds good in theory, but in practice there's the 
often underestimated high price of people using a different solution 
instead of reporting a problem with one solution or people adding 
features to only one of the solutions resulting in different solutions 
having different features and bugs instead of one solution with all 
features and bug fixes.

So you should give a good technical explanation why it's not technically 
possible or not desirable for one solution to work well for everyone.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

