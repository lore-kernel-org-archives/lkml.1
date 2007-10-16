Return-Path: <linux-kernel-owner+w=401wt.eu-S1765204AbXJPJkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765204AbXJPJkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXJPJjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:39:53 -0400
Received: from mx2.go2.pl ([193.17.41.42]:43414 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758132AbXJPJjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:39:52 -0400
Date: Tue, 16 Oct 2007 11:42:52 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
Message-ID: <20071016094252.GD1000@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471410EF.90808@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-10-2007 03:16, Peter Williams wrote:
...
> 
> I'd suggest that we modify sched_rr_get_interval() to return -EINVAL 
> (with *interval set to zero) if the target task is not SCHED_RR.  That 
> way we can save a lot of unnecessary code.  I'll work on a patch.
...

I like this idea! But, since this a system call maybe at least
something like RFC would be nicer...

>>
>> Sorry for too harsh words.
> 
> I didn't consider them harsh.

So, I can't be mistaken for a rapper yet? I'll work on it...

Cheers,
Jarek P.

PS: Peter, for some unknown reason I don't receive your messages.
If you get back some errors from my side I'd be interested to see
it (alternative: jarkao2 at gmail.com).
