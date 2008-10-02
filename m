Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYJBS7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYJBS7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYJBS67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:58:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbYJBS66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:58:58 -0400
Date: Thu, 2 Oct 2008 20:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [boot crash] Re: [PATCH] ring-buffer: fix build error
Message-ID: <20081002185509.GA32078@elte.hu>
References: <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810020916580.19018@gandalf.stny.rr.com> <20081002155053.GA31953@elte.hu> <alpine.DEB.1.10.0810021426080.2919@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810021426080.2919@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 2 Oct 2008, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > On Thu, 2 Oct 2008, Ingo Molnar wrote:
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > full serial log and config attached. I'm excluding these latest commits 
> > > 
> > >  -ENOATTACHMENT
> > 
> > attached.
> > 
> > You can get the broken tree by doing this in tip/master:
> > 
> >   git-merge tip/tracing/ring-buffer
> 
> I've just checked-out tip/tracing/ring-buffer. That tree is still broken 
> too, right? Or do I need to merge it to get the broken version?

yes, that's very likely broken too in a standalone way as well - but to 
get the exact tree i tested i'd suggest:

  git checkout tip/master
  git merge tip/tracing/ring-buffer

	Ingo
