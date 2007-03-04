Return-Path: <linux-kernel-owner+w=401wt.eu-S1751711AbXCDOLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbXCDOLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXCDOLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:11:39 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:43395 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXCDOLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:11:38 -0500
Date: Sun, 04 Mar 2007 09:11:16 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <200703050049.50149.kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Cc: Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>
Message-id: <200703040911.16845.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703041800.53360.kernel@kolivas.org>
 <200703040825.42047.gene.heskett@gmail.com>
 <200703050049.50149.kernel@kolivas.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007, Con Kolivas wrote:
>On Monday 05 March 2007 00:25, Gene Heskett wrote:
>> On Sunday 04 March 2007, Con Kolivas wrote:
>> >On Sunday 04 March 2007 23:24, Gene Heskett wrote:
>> >> On Sunday 04 March 2007, Con Kolivas wrote:
>> >> >On Sunday 04 March 2007 22:08, Gene Heskett wrote:
>> >> >> On Sunday 04 March 2007, Con Kolivas wrote:
>> >> >> >This message is to announce the first general public release of
>> >> >> > the "Rotating Staircase DeadLine" cpu scheduler.
>> >> >>
>> >> >> I assume to test this, we select the deadline scheduler?
>> >> >
>> >> >No, only the "deadline" in the name is shared. This is a cpu
>> >> > process scheduler whereas the deadline scheduler you're thinking
>> >> > of is an I/O scheduler. To test this you just patch it in and it
>> >> > replaces the current mainline cpu scheduler (the same way the
>> >> > staircase cpu scheduler in -ck replaces it).
>> >>
>> >> Oh, then I tried to put the -ck1 patch on top of that, and blew the
>> >> tree up.  I'd built it the first time with the deadline scheduler
>> >> as the default while I was waiting on your reply.
>> >
>> >Yes, sorry. This is mutually exclusive with the -ck1 patch. It is a
>> > standalone piece of code.
>>
>> I just this instant got it booted, what with building a driver for
>> nvidia and all.  I'll let you know what I think in a few hours after
>> I've gotten a feel for it.
>
>Great, thanks.
>
>Just to make it clear. The purpose of this scheduler is at all costs to
>maintain absolute fairness no matter what type of load it is put under.
> This means that if you heavily load up your machine without the use of
> 'nice' then your interactive tasks _will_ slow down proportionately to
> the amount of cpu you use. So doing make -j4 for example will make any
> other task started in taht presence run precisely 1/5th speed, but they
> will still be responsive, have low latency (and audio shouldn't skip
> for example).
>
>There will be times when the mainline scheduler feels more interactive
> than this scheduler, and that is because it has significant unfairness
> granted towards interactive tasks. This degree of unfairness in an
> effort to maintain interactivity has been criticised and causes
> problems in certain environments with both loss of fairness, relative
> starvation and is not entirely predictable.

Well, in 20 minutes of playing, I am so far VERY impressed, the kmail 
composer is typing to the screen in unison to my keystrokes, where with 
the older version it often went away for 10 or more seconds at a time, 
then displayed the last sentence I had typed in one (or 2 sometimes) 
swell foop.  Now I can back up and correct a typo in real time whereas 
before, it was often faster if the typo was half a line back, and the key 
repeat so darned slow it was often over a second per character cell 
moved, to go grab the mouse, position the cursor on the typo, click, wait 
for the indicator to move, and then fix it.  Typing is now pleasurable 
again.  Key repeats seem to remain at the set in the bios key repeat 
speed.  Amazing.  I do believe you have given me back my machine.

I may find something to squawk about in due time, I think that Murphy guys 
laws may have a corollary on that subject, but it sure feels good right 
now.

>This was designed to be robust for any application since linux demands a
>general purpose scheduler design, while preserving interactivity,
> instead of optimising for one particular end use.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
