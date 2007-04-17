Return-Path: <linux-kernel-owner+w=401wt.eu-S1031074AbXDQERf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031074AbXDQERf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbXDQERf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:17:35 -0400
Received: from omta05sl.mx.bigpond.com ([144.140.93.195]:45488 "EHLO
	omta05sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbXDQERe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:17:34 -0400
Message-ID: <46244A52.4000403@bigpond.net.au>
Date: Tue, 17 Apr 2007 14:17:22 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de>
In-Reply-To: <20070417034050.GD25513@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 04:17:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tue, Apr 17, 2007 at 04:29:01AM +0200, Mike Galbraith wrote:
>> On Tue, 2007-04-17 at 10:06 +1000, Peter Williams wrote:
>>> Mike Galbraith wrote:
>>>> Demystify what?   The casual observer need only read either your attempt
>>>> at writing a scheduler, or my attempts at fixing the one we have, to see
>>>> that it was high time for someone with the necessary skills to step in.
>>> Make that "someone with the necessary clout".
>> No, I was brutally honest to both of us, but quite correct.
>>
>>>> Now progress can happen, which was _not_ happening before.
>>>>
>>> This is true.
>> Yup, and progress _is_ happening now, quite rapidly.
> 
> Progress as in progress on Ingo's scheduler. I still don't know how we'd
> decide when to replace the mainline scheduler or with what.
> 
> I don't think we can say Ingo's is better than the alternatives, can we?
> If there is some kind of bakeoff, then I'd like one of Con's designs to
> be involved, and mine, and Peter's...

I myself was thinking of this as the chance for a much needed 
simplification of the scheduling code and if this can be done with the 
result being "reasonable" it then gives us the basis on which to propose 
improvements based on the ideas of others such as you mention.

As the size of the cpusched indicates, trying to evaluate alternative 
proposals based on the current O(1) scheduler is fraught.  Hopefully, 
this initiative can fix this problem.  Then we just need Ingo to listen 
to suggestions and he's showing signs of being willing to do this :-)

> 
> Maybe the progress is that more key people are becoming open to the idea
> of changing the scheduler.

That too.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
