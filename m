Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZLWIDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZLWIDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZLWIDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:03:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZLWIDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:03:10 -0500
Date: Wed, 23 Dec 2009 09:01:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091223080144.GG23839@elte.hu>
References: <4B2EE5A5.2030208@kernel.org>
 <1261387377.4314.37.camel@laptop>
 <4B2F7879.2080901@kernel.org>
 <1261405604.4314.154.camel@laptop>
 <4B3009DC.7020407@kernel.org>
 <1261480001.4937.21.camel@laptop>
 <4B319A20.9010305@kernel.org>
 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
 <20091223060229.GA14805@elte.hu>
 <4B31C210.4010100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31C210.4010100@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> > We really are not forced to the space of Gedankenexperiments here.
> 
> Sure but there's a reason why I posted the patchset without the actual 
> conversions.  I wanted to make sure that it's not rejected on the ground of 
> its basic design.  I thought it was acceptable after the first RFC round but 
> while trying to merge the scheduler part, Peter seemed mightily unhappy with 
> the whole thing, so this second RFC round.  So, if anyone has major issues 
> with the basic design, please step forward *now* before I go spending more 
> time working on it.

At least as far as i'm concerned, i'd like to see actual uses. It's a big 
linecount increase all things considered:

   20 files changed, 2783 insertions(+), 660 deletions(-)

and you say it _wont_ help performance/scalability (this aspect wasnt clear to 
me from previous discussions), so the (yet to be seen) complexity reduction in 
other code ought to be worth it.

	Ingo
