Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZLWIZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZLWIZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZLWIZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:25:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZLWIZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:25:48 -0500
Message-ID: <4B31D487.6060706@kernel.org>
Date: Wed, 23 Dec 2009 17:27:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <4B2EE5A5.2030208@kernel.org> <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu> <4B31C210.4010100@kernel.org> <20091223080144.GG23839@elte.hu>
In-Reply-To: <20091223080144.GG23839@elte.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/23/2009 05:01 PM, Ingo Molnar wrote:
> At least as far as i'm concerned, i'd like to see actual uses. It's a big 
> linecount increase all things considered:
> 
>    20 files changed, 2783 insertions(+), 660 deletions(-)
> 
> and you say it _wont_ help performance/scalability (this aspect
> wasnt clear to me from previous discussions),

I'm just not sure how it would turn out.  I guess it would be an
overall win under loaded situations due to lowered cache footprint but
I don't think it will be anything which would stand out.

> so the (yet to be seen) complexity reduction in other code ought to
> be worth it.

Sure, fair enough but there's also a different side.  It'll allow much
easier implementation of things like in-kernel media presence polling
(I have some code for this but it's still just forming) and
per-device.  It gives a much easier tool to extract concurrency and
thus opens up new possibilities.

So, anyways, alright, I'll go try some conversions.

Happy holidays.

-- 
tejun
