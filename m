Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZGEAdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZGEAdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 20:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZGEAdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 20:33:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45875 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZGEAdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 20:33:04 -0400
Date: Sun, 5 Jul 2009 02:32:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: Roland Dreier <rdreier@cisco.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
Message-ID: <20090705003239.GB28564@elte.hu>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain> <20090625093346.GD23547@elte.hu> <1245934522.5308.39.camel@hpdv5.satnam> <ada3a9ol58t.fsf@cisco.com> <20090705002536.GA28060@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705002536.GA28060@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> 
> Hi,
> 
> > IMHO "L1d" is too abbreviated for it to be obvious that it means L1 data
> > cache.  If you want something really short maybe "L1-d$" might be a
> > little clearer, but I stil like "L1-dcache" best.
> 
> There's one problem with L1-d$-* for event names. It took me a few goes
> before I realised I was being hit by bash variable expansion:
> 
> 
> #  perf stat -e L1-d$-loads ls
> 
>  usage: perf stat [<options>] <command>
> 
> ...
> 
> 
> # perf stat -e 'L1-d$-loads' ls
> 
>  Performance counter stats for 'ls':
> 
>         1273291  L1-d$-loads             
> 
>     0.004434037  seconds time elapsed
> 
> 
> I also prefer the more verbose L1-dcache-* names, and since we 
> support aliases its mostly a matter of screen real estate when 
> printing out the statistics.

ok - mind sending a patch for this?

	Ingo
