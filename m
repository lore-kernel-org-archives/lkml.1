Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXLCV5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXLCV5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXLCV5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:57:13 -0500
Received: from rtr.ca ([76.10.145.34]:4799 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbXLCV5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:57:12 -0500
Message-ID: <47547BB6.3040402@rtr.ca>
Date: Mon, 03 Dec 2007 16:57:10 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Friesen <cfriesen@nortel.com>, davids@webmaster.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com> <47545F88.6070609@nortel.com> <4754777F.7020302@rtr.ca> <20071203214803.GA8989@elte.hu>
In-Reply-To: <20071203214803.GA8989@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mark Lord <lkml@rtr.ca> wrote:
> 
>> That's not the same thing at all. I think that David is suggesting 
>> that the reinsertion logic should pretend that the task used up all of 
>> the CPU time it was offered in the slot leading up to the 
>> sched_yield() call.
> 
> we have tried this too, and this has problems too (artificial inflation 
> of the vruntime metric and a domino effects on other portions of the 
> scheduler). So this is a worse solution than what we have now. (and this 
> has all been pointed out in past discussions in which David 
> participated. I'll certainly reply to any genuinely new idea.)
..

Ack.  And what of the suggestion to try to ensure that a yielding task
simply not end up as the very next one chosen to run?  Maybe by swapping
it with another (adjacent?) task in the tree if it comes out on top again?

(I really don't know the proper terminology to use here,
 but hopefully Ingo can translate that).

That's probably already been covered too, but are the prior conclusions still valid?

Thanks Ingo -- I *really* like this scheduler!
