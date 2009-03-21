Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZCUPwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZCUPwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZCUPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:52:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZCUPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:52:14 -0400
Date: Sat, 21 Mar 2009 16:52:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perfcounters: record time running and time enabled
	for each counter
Message-ID: <20090321155202.GA6356@elte.hu>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com> <20090321055252.eb0673ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321055252.eb0673ea.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	u64				time_enabled;
> > +	u64				time_running;
> 
> These look like times.  I see no indication (here) as to the units.
> 
> > +	u64				start_enabled;
> 
> This looks like a boolean, but it's u64.
> 
> > +	u64				start_running;
> 
> hard to say.
> 
> > +	u64				last_stopped;
> 
> probably a time, unknown units.
> 
> 
> Perhaps one of the reasons why this code is confusing is the 
> blurring between the "time" at which an event occured and the 
> "time" between the occurrence of two events.  A weakness in 
> English, I guess.  Using the term "interval" in the latter case 
> will help a lot.

What we use in the scheduler is "sum_time" or "runtime". A bit of a 
tongue twister but unambiguous.

	Ingo
