Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZLWHyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZLWHyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 02:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZLWHyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 02:54:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZLWHyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 02:54:07 -0500
Date: Wed, 23 Dec 2009 08:53:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091223075309.GF23839@elte.hu>
References: <4B2EE5A5.2030208@kernel.org>
 <1261387377.4314.37.camel@laptop>
 <4B2F7879.2080901@kernel.org>
 <1261405604.4314.154.camel@laptop>
 <4B3009DC.7020407@kernel.org>
 <1261480001.4937.21.camel@laptop>
 <4B319A20.9010305@kernel.org>
 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
 <20091223060229.GA14805@elte.hu>
 <4B31B508.5040903@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31B508.5040903@garzik.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> On 12/23/2009 01:02 AM, Ingo Molnar wrote:
> >One key thing i havent seen in this discussion are actual measurements. I
> >think a lot could be decided by simply testing this patch-set, by looking at
> >the hard numbers: how much faster (or slower) did a particular key workload
> >get before/after these patches.
> 
> We are dealing with situations where drivers are using workqueues to
> provide a sleep-able context, and trying to solve problems related
> to that.
> 
> "faster or slower?" is not very relevant for such cases.

Claims to performance were made though, so it's a valid question.

But it's not the only effect, which is why i continued my email with the issue 
you raised:

> > Likewise, if there's a reduction in complexity, that is a tangible metric 
> > as well: lets do a few conversions as part of the patch-set and see how 
> > much simpler things have become as a result of it.
> >
> > We really are not forced to the space of Gedankenexperiments here.

Thanks,

	Ingo
