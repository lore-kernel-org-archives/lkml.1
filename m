Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbXKGS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbXKGS7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXKGS7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:59:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40379 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbXKGS7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:59:13 -0500
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, pwil3058@bigpond.net.au, linux-kernel@vger.kernel.org
In-Reply-To: <20071107102725.64514fde.akpm@linux-foundation.org>
References: <1194434956.6289.111.camel@twins>
	 <1194437820.6289.114.camel@twins>
	 <20071107102725.64514fde.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 19:58:53 +0100
Message-Id: <1194461933.6289.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 10:27 -0800, Andrew Morton wrote:
> > On Wed, 07 Nov 2007 13:17:00 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> > +	{
> > +		.ctl_name	= CTL_UNNUMBERED,
> > +		.procname	= "sched_nr_migrate",
> > +		.data		= &sysctl_sched_nr_migrate,
> > +		.maxlen		= sizeof(unsigned int),
> > +		.mode		= 644,
> > +		.proc_handler	= &proc_dointvec,
> > +	},
> 
> This (and all the other stuff in that table) should be described in
> Documentation/, please.
> 
> It would be nice if sched_nr_migrate didn't exist, really.  It's hard to
> imagine anyone wanting to tweak it, apart from developers.

Right, most of these SCHED_DEBUG sysctls are only interesting to
developers, although stuff like sched_latency might be interesting to
some users.

I'll try and write up a documentation thingy before .24 hits the street.



