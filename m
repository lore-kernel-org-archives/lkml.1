Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbXDURkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbXDURkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 13:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXDURkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 13:40:53 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46796 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbXDURkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 13:40:52 -0400
Date: Sat, 21 Apr 2007 19:15:19 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Con Kolivas <kernel@kolivas.org>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-Reply-To: <20070421160008.GA28783@elte.hu>
Message-ID: <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
 <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 21 2007 18:00, Ingo Molnar wrote:
>* Con Kolivas <kernel@kolivas.org> wrote:
>
>> >   Feels even better, mouse movements are very smooth even under high 
>> >   load. I noticed that X gets reniced to -19 with this scheduler. 
>> >   I've not looked at the code yet but this looked suspicious to me. 
>> >   I've reniced it to 0 and it did not change any behaviour. Still 
>> >   very good.
>> 
>> Looks like this code does it:
>> 
>> +int sysctl_sched_privileged_nice_level __read_mostly = -19;
>
>correct. Note that Willy reniced X back to 0 so it had no relevance on 
>his test. Also note that i pointed this change out in the -v4 CFS 
>announcement:
>
>|| Changes since -v3:
>||
>||  - usability fix: automatic renicing of kernel threads such as 
>||    keventd, OOM tasks and tasks doing privileged hardware access
>||    (such as Xorg).
>
>i've attached it below in a standalone form, feel free to put it into 
>SD! :)

Assume X went crazy (lacking any statistics, I make the unproven
statement that this happens more often than kthreads going berserk),
then having it niced with minus something is not too nice.



Jan
-- 
