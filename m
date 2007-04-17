Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXDQERL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXDQERL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbXDQERL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:17:11 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:53467 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932244AbXDQERK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:17:10 -0400
Date: Mon, 16 Apr 2007 20:43:38 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Mike Galbraith <efault@gmx.de>
cc: Nick Piggin <npiggin@suse.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely 
 FairScheduler [CFS]
In-Reply-To: <1176782489.13059.15.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.63.0704162039540.1277@qynat.qvtvafvgr.pbz>
References: <20070413202100.GA9957@elte.hu>  <200704151327.13589.kernel@kolivas.org>
  <1176619384.6222.70.camel@Homer.simpson.net>  <46240F98.3020800@bigpond.net.au>
  <1176776941.6222.21.camel@Homer.simpson.net>  <20070417034050.GD25513@wotan.suse.de>
 <1176782489.13059.15.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Mike Galbraith wrote:

> Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely
>     FairScheduler [CFS]
> 
> On Tue, 2007-04-17 at 05:40 +0200, Nick Piggin wrote:
>> On Tue, Apr 17, 2007 at 04:29:01AM +0200, Mike Galbraith wrote:
>
>>> Yup, and progress _is_ happening now, quite rapidly.
>>
>> Progress as in progress on Ingo's scheduler. I still don't know how we'd
>> decide when to replace the mainline scheduler or with what.
>>
>> I don't think we can say Ingo's is better than the alternatives, can we?
>
> No, that would require massive performance testing of all alternatives.
>
>> If there is some kind of bakeoff, then I'd like one of Con's designs to
>> be involved, and mine, and Peter's...
>
> The trouble with a bakeoff is that it's pretty darn hard to get people
> to test in the first place, and then comes weighting the subjective and
> hard performance numbers.  If they're close in numbers, do you go with
> the one which starts the least flamewars or what?

it's especially hard if the people doing the testing need to find the latest 
patch and apply it.

even having a compile-time option to switch between them at least means that the 
testers can have confidence that the various patches haven't bitrotted.

boot time options would be even better, but I understand from previous 
discussions I've watched that this is performance critical enough that the 
overhead of this would throw off the results.

David Lang
