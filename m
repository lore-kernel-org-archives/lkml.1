Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbXCIEBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbXCIEBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXCIEBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:01:46 -0500
Received: from mail.tmr.com ([64.65.253.246]:33337 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbXCIEBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:01:45 -0500
Message-ID: <45F0DCB7.5020908@tmr.com>
Date: Thu, 08 Mar 2007 23:04:07 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ed Tomlinson <edt@aei.ca>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Revell <rlrevell@joe-job.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
   scheduler
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org> <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com> <200703051419.25814.gene.heskett@gmail.com> <200703052123.29421.edt@aei.ca> <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703051849410.3998@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 5 Mar 2007, Ed Tomlinson wrote:
>> The patch _does_ make a difference.  For instance reading mail with freenet working 
>> hard  (threaded java application) and gentoo's emerge triggering compiles to update the 
>> box is much smoother.
>>
>> Think this scheduler needs serious looking at.  
> 
> I agree, partly because it's obviously been getting rave reviews so far, 
> but mainly because it looks like you can think about behaviour a lot 
> better, something that was always very hard with the interactivity 
> boosters with process state history.
> 
> I'm not at all opposed to this, but we do need:
>  - to not do it at this stage in the stable kernel
>  - to let it sit in -mm for at least a short while
>  - and generally more people testing more loads.
> 
Please, could you now rethink plugable scheduler as well? Even if one 
had to be chosen at boot time and couldn't be change thereafter, it 
would still allow a few new thoughts to be included.

> I don't actually worry too much about switching out a CPU scheduler: those 
> things are places where you *can* largely read the source code and get an 
> idea for them (although with the kind of history state that we currently 
> have, it's really really hard). But at the very least they aren't likely 
> to have subtle bugs that show up elsewhere, so...
> 
I confess that the default scheduler works for me most of the time, i/o 
tuning is more productive. I want tot test with kvm load, but 
2.6.21-rc3-git3 doesn't want to run kvm at all, I'm looking to see what 
I broke, since nbd doesn't work, either.

I'm collecting OOPS now, will forward when I have a few more.

> So as long as the generic concerns above are under control, I'll happily 
> try something like this if it can be merged early in a merge window..
> 
> 			Linus


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
