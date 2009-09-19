Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbZISJo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbZISJo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZISJo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:44:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZISJo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:44:57 -0400
Date: Sat, 19 Sep 2009 11:44:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com
Subject: Re: [PATCH 7/8] perf: Add a perf record --timechart option
Message-ID: <20090919094452.GA2295@elte.hu>
References: <20090912130306.5d0086ea@infradead.org> <20090912130645.2765de6d@infradead.org> <1252915560.5699.35.camel@laptop> <20090914223303.0e595bb2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914223303.0e595bb2@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 14 Sep 2009 10:06:00 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2009-09-12 at 13:06 +0200, Arjan van de Ven wrote:
> > > This patch adds a "perf record --timechart" option, to make it easy
> > > to capture traces for use by the timechart tool.
> > 
> > Would it perhaps make sense to make that:
> > 
> >  perf timechart record
> 
> well yes, but it would just be an alias for the former, since it's the 
> record code that has to do the recording... and that's a rather 
> obscene layering violation in how perf is set up I think.

No, please do it like 'perf sched record' does - it constructs an 
argument list of pre-cooked options. See builtin-sched.c's record_args[] 
array.

	Ingo
