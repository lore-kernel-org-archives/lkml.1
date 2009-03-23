Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZCWWHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZCWWHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZCWWHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:07:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52449 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZCWWHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:07:42 -0400
Date: Mon, 23 Mar 2009 23:06:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [tree] Performance Counters for Linux, v7
Message-ID: <20090323220630.GA12992@elte.hu>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com> <20090321055252.eb0673ea.akpm@linux-foundation.org> <20090321155442.GB6356@elte.hu> <20090321161021.GA9826@elte.hu> <1237704538.29643.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237704538.29643.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sat, 2009-03-21 at 17:10 +0100, Ingo Molnar wrote:
> 
> > There's also been lots of updates to the userspace tools (kerneltop 
> > and perfstat):
> > 
> >    http://redhat.com/~mingo/perfcounters/kerneltop.c
> >    http://redhat.com/~mingo/perfcounters/perfstat.c
> > 
> 
> If possible, can we also prepare git tree for these userspace 
> tools by this way we can also look on logs and check incremental 
> changes otherwise we leads to:
> 
> [jaswinder@hpdv5 20090321]$ cc -O2 -g -lrt -Wall -W -o perfstat perfstat.c
> perfstat.c:57:40: error: include/linux/perf_counter.h: No such file or directory

to get the latest perfcounter tools, do this on latest -tip:

   cd Documentation/perf_counter/
   make

which will build the sample tools. kerneltop and perfstat has been 
unified into a single .c file by Wu Fengguang, with updates by Peter 
Zijstra.

	Ingo
