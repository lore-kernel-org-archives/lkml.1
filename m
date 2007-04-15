Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXDOIpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXDOIpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 04:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXDOIpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 04:45:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbXDOIpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 04:45:35 -0400
Date: Sun, 15 Apr 2007 10:44:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415084447.GC24886@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415051645.GA28438@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> Hello folks,
> 
> I think the main failure I see here is that Con wasn't included in 
> this design or privately in review process. There could have been 
> better co-ownership of the code. This could also have been done openly 
> on lkml [...]

Bill, you come from a BSD background and you are still relatively new to 
Linux development, so i dont at all fault you for misunderstanding this 
situation, and fortunately i have a really easy resolution for your 
worries: i did exactly that! :)

i wrote the first line of code of the CFS patch this week, 8am Wednesday 
morning, and released it to lkml 62 hours later, 22pm on Friday. (I've 
listed the file timestamps of my backup patches further below, for all 
the fine details.)

I prefer such early releases to lkml _alot_ more than any private review 
process. I released the CFS code about 6 hours after i thought "okay, 
this looks pretty good" and i spent those final 6 hours on testing it 
(making sure it doesnt blow up on your box, etc.), in the final 2 hours 
i showed it to two folks i could reach on IRC (Arjan and Thomas) and on 
various finishing touches. It doesnt get much faster than that and i 
definitely didnt want to sit on it even one day longer because i very 
much thought that Con and others should definitely see this work!

And i very much credited (and still credit) Con for the whole fairness 
angle:

||  i'd like to give credit to Con Kolivas for the general approach here:
||  he has proven via RSDL/SD that 'fair scheduling' is possible and that
||  it results in better desktop scheduling. Kudos Con!

the 'design consultation' phase you are talking about is _NOW_! :)

I got the v1 code out to Con, to Mike and to many others ASAP. That's 
how you are able to comment on this thread and be part of the 
development process to begin with, in a 'private consultation' setup 
you'd not have had any opportunity to see _any_ of this.

In the BSD space there seem to be more 'political' mechanisms for 
development, but Linux is truly about doing things out in the open, and 
doing it immediately.

Okay? ;-)

Here's the timestamps of all my backups of the patch, from its humble 4K 
beginnings to the 100K first-cut v1 result:

-rw-rw-r-- 1 mingo mingo 4230 Apr 11 08:47 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 7653 Apr 11 09:12 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 7728 Apr 11 09:26 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 14416 Apr 11 10:08 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 24211 Apr 11 10:41 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 27878 Apr 11 10:45 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 33807 Apr 11 11:05 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 34524 Apr 11 11:09 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 39650 Apr 11 11:19 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 40231 Apr 11 11:34 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 40627 Apr 11 11:48 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 40638 Apr 11 11:54 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 42733 Apr 11 12:19 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 42817 Apr 11 12:31 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 43270 Apr 11 12:41 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 43531 Apr 11 12:48 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 44331 Apr 11 12:51 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45173 Apr 11 12:56 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45288 Apr 11 12:59 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45368 Apr 11 13:06 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45370 Apr 11 13:06 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45815 Apr 11 13:14 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45887 Apr 11 13:19 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45914 Apr 11 13:25 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 45850 Apr 11 13:29 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 49196 Apr 11 13:39 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 64317 Apr 11 13:45 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 64403 Apr 11 13:52 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 65199 Apr 11 14:03 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 65199 Apr 11 14:07 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 68995 Apr 11 14:50 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 69919 Apr 11 15:23 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 71065 Apr 11 16:26 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 70642 Apr 11 16:28 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 72334 Apr 11 16:49 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 71624 Apr 11 17:01 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 71854 Apr 11 17:20 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 73571 Apr 11 17:42 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 74708 Apr 11 17:49 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 74708 Apr 11 17:51 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 75144 Apr 11 17:57 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 80722 Apr 11 18:19 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 80727 Apr 11 18:41 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 80727 Apr 11 18:59 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 89356 Apr 11 21:32 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 95278 Apr 12 08:36 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 97749 Apr 12 10:49 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 97687 Apr 12 10:58 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 97722 Apr 12 11:06 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 97933 Apr 12 11:22 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 98167 Apr 12 12:04 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 98167 Apr 12 12:09 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 100405 Apr 12 12:29 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 100380 Apr 12 12:50 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 101631 Apr 12 13:32 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 102293 Apr 12 14:12 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 102431 Apr 12 14:28 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 102502 Apr 12 14:53 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 102128 Apr 13 11:13 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 102473 Apr 13 12:12 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 102536 Apr 13 12:24 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 102481 Apr 13 12:30 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 103408 Apr 13 13:08 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 103441 Apr 13 13:31 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 104759 Apr 13 14:19 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 104815 Apr 13 14:39 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 104762 Apr 13 15:04 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 105978 Apr 13 16:18 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 105977 Apr 13 16:26 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 106761 Apr 13 17:08 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 106358 Apr 13 17:40 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 107802 Apr 13 19:04 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 104427 Apr 13 19:35 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 103927 Apr 13 19:40 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 101867 Apr 13 20:30 patches/sched-fair.patch
-rw-rw-r-- 1 mingo mingo 101011 Apr 13 21:05 patches/sched-fair.patch

i hope this helps :)

	Ingo
