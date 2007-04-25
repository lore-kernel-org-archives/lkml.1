Return-Path: <linux-kernel-owner+w=401wt.eu-S1161819AbXDYAa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161819AbXDYAa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161823AbXDYAa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:30:59 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:42860 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161819AbXDYAa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:30:58 -0400
Date: Tue, 24 Apr 2007 20:30:47 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-reply-to: <20070424174445.GA31270@1wt.eu>
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, David Lang <david.lang@digitalinsight.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
Message-id: <200704242030.48071.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704220959.34978.kernel@kolivas.org>
 <200704241038.32766.gene.heskett@gmail.com> <20070424174445.GA31270@1wt.eu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007, Willy Tarreau wrote:
>On Tue, Apr 24, 2007 at 10:38:32AM -0400, Gene Heskett wrote:
>> On Tuesday 24 April 2007, Ingo Molnar wrote:
>> >* David Lang <david.lang@digitalinsight.com> wrote:
>> >> > (Btw., to protect against such mishaps in the future i have changed
>> >> > the SysRq-N [SysRq-Nice] implementation in my tree to not only
>> >> > change real-time tasks to SCHED_OTHER, but to also renice negative
>> >> > nice levels back to 0 - this will show up in -v6. That way you'd
>> >> > only have had to hit SysRq-N to get the system out of the wedge.)
>> >>
>> >> if you are trying to unwedge a system it may be a good idea to renice
>> >> all tasks to 0, it could be that a task at +19 is holding a lock that
>> >> something else is waiting for.
>> >
>> >Yeah, that's possible too, but +19 tasks are getting a small but
>> >guaranteed share of the CPU so eventually it ought to release it. It's
>> >still a possibility, but i think i'll wait for a specific incident to
>> >happen first, and then react to that incident :-)
>> >
>> >	Ingo
>>
>> In the instance I created, even the SysRq+b was ignored, and ISTR thats
>> supposed to initiate a reboot is it not?  So it was well and truly wedged.
>
>On many machines I use this on, I have to release Alt while still holding B.
>Don't know why, but it works like this.
>
>Willy

Yeah, Willy, and pardon a slight bit of sarcasm here but that's how we get the 
reputation for needing virgins to sacrifice, regular experienced girls just 
wouldn't do.

This isn't APL running on an IBM 5120, so it should Just Work(TM) and not need 
a sceance or something to conjure up the right spell.  Besides, the reset 
button is only about 6 feet away...  I get some execsize that way by getting 
up to push it. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It is so soon that I am done for, I wonder what I was begun for.
		-- Epitaph, Cheltenham Churchyard
