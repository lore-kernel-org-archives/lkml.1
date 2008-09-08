Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYIHSje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYIHSje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYIHSjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:39:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39975 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbYIHSjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:39:23 -0400
Date: Mon, 8 Sep 2008 20:38:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in
	kernel/sched.c
Message-ID: <20080908183852.GA3713@elte.hu>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080906235037.880702000@polaris-admin.engr.sgi.com> <1220783087.8687.73.camel@twins.programming.kicks-ass.net> <48C53C91.70604@sgi.com> <1220886335.12278.31.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220886335.12278.31.camel@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > > NAK
> > 
> > Yeah, I really agree as well.  But I wanted to start playing with 
> > using cpumask_t pointers in some fairly straight forward manner.  
> > Linus's and Ingo's suggestion to just bite the bullet and redefine 
> > the cpumask_t would force a lot of changes to be made, but perhaps 
> > that's really the way to go.
> 
> I much prefer that approach!

seconded. Mike, since none of this is v2.6.27 material, lets do it right 
with a v2.6.28 target. You know all the cpumask_t using code sites 
inside out already, so the know-how is all available already :-) Please 
make it finegrained series of patches so that we can resolve conflicts 
with other trees more easily.

perhaps propose the new cpumask_t API early (in this thread?), so that 
people can comment on it before NAKs come flying against a full patchset 
;-)

	Ingo
