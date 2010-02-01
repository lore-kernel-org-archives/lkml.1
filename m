Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab0BAJXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:23:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0BAJXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:23:30 -0500
Date: Mon, 1 Feb 2010 10:22:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
 analyzing  lock statistics
Message-ID: <20100201092239.GA22578@elte.hu>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20100129143403.GJ13771@kernel.dk>
 <4B641F4D.6090704@dcl.info.waseda.ac.jp>
 <20100131204408.GC13771@kernel.dk>
 <20100131210707.GF5224@nowhere>
 <1265015720.24455.101.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265015720.24455.101.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2010-01-31 at 22:07 +0100, Frederic Weisbecker wrote:
> > 
> > - We are using the -M option from perf tools which multiplexes every
> >   event buffers, which means every cpu commit their lock events in
> >   the same buffer. Couple that with the two above reasons, it's supposed
> >   to scale at worst.
> 
> Why are you doing that? That seems like asking for trouble.. 

But as i said i already tried with -M off and it didnt cure the slowdown.

that -M was just copied over from perf sched (where it makes sense).

	Ingo
