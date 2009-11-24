Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZKXJQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZKXJQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932405AbZKXJQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:16:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35994 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbZKXJQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:16:42 -0500
Date: Tue, 24 Nov 2009 10:16:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091124091630.GH21991@elte.hu>
References: <20091123112228.GA2287@wotan.suse.de>
 <1258987059.6193.73.camel@marge.simson.net>
 <20091123151152.GA19175@wotan.suse.de>
 <1258989704.4531.574.camel@laptop>
 <20091123152931.GD19175@wotan.suse.de>
 <20091123170445.GA29058@elte.hu>
 <20091124065910.GE20981@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124065910.GE20981@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Mon, Nov 23, 2009 at 06:04:45PM +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > > .32 is kind of closed, with us being at -rc8.
> > > 
> > > It's a bad regression though.
> > 
> > It's about 3 months too late for that. Ideally we want performance 
> 
> Too late for what?  Reporting and reverting a regression?

Yes, the revert would be too intrusive so late in the release cycle, 
sorry. For such types of scheduler reverts we rarely go beyond -rc5 - 
the risks of breaking something are too big.

Note that we have queued up a fix for that about two weeks ago for 
v2.6.33 - that fix could be forwarded to stable@kernel.org for 2.6.32.1 
merging.

> [...] I don't think so. It is not my problem if patches aren't tested 
> well enough before being merged.

There's certainly a wide performance testing being done for scheduler 
relevant workloads all the time. If you dont like the end result you are 
welcome to help out testing and fixing things (and certainly both).

I'd also welcome help from you to extend 'perf bench sched' with new 
testcases. (it has only two so far - the tool just got started so 
there's lots of low hanging fruits.) 'perf bench sched numa-cost' would 
certainly be usefulful to have.

Thanks,

	Ingo
