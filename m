Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545Ab0ATFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0ATFuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 00:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125Ab0ATFuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 00:50:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59173 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab0ATFuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 00:50:22 -0500
Date: Wed, 20 Jan 2010 06:49:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, utrace-devel@redhat.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100120054950.GB27108@elte.hu>
References: <20100119211646.GF16096@redhat.com>
 <20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Frank,
> 
> On Tue, 19 Jan 2010 16:16:46 -0500 "Frank Ch. Eigler" <fche@redhat.com> wrote:
> >
> > Having been reviewed a couple of times, and we hope being a good
> > candidate for merging next time, please start pulling
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git branch master
> 
> I have added this from today with you and utrace-devel as the contacts.
> I have cc'd the wider community on this email so that people are aware
> that this has been included.
> 
> > This repo contains frequent merges from Linus' tree.  If you'd prefer
> > a cleaner rebase-based branch to pull from, we can make one of those too.
> 
> For now it is OK, but you might like to ask Linus if he would like it
> cleaned up before submission since it seems to have history right back to
> 2.6.29 and (as you say) lots of merges with his tree.
> 
> You should also add a commit with an entry in MAINTAINERS.

Note, i'm not yet convinced that this (and the rest: uprobes and systemtap, 
etc.) can go uptream in its present form.

IMHO the far more important thing to address beyond formalities and workflow 
cleanliness are the (many) technical observations and objections offered by 
Peter Zijstra on lkml. Not just the git history but also the abstractions and 
concepts are messy and should be reworked IMO, and also good and working perf 
events integration should be achieved, etc.

The fact that there's a well established upstream workflow for instrumentation 
patches, which is being routed around by the utrace/uprobes/systemtap code 
here is not a good sign in terms of reaching a good upstream solution. Lets 
hope it works out well though.

Thanks,

	Ingo
