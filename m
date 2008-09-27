Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYI0Umg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYI0Umg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYI0Um2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:42:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYI0Um2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:42:28 -0400
Date: Sat, 27 Sep 2008 22:34:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Bligh <mbligh@mbligh.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v9] Unified trace buffer
Message-ID: <20080927203427.GD28937@elte.hu>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <20080927183912.GA13685@elte.hu> <alpine.DEB.1.10.0809271444460.11865@gandalf.stny.rr.com> <20080927194105.GF18619@elte.hu> <alpine.DEB.1.10.0809271549160.16572@gandalf.stny.rr.com> <8f3aa8d60809271307o1c306eccm5571670090218ab9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f3aa8d60809271307o1c306eccm5571670090218ab9@mail.gmail.com>
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


* Martin Bligh <mbligh@mbligh.org> wrote:

> >> that's even worse i think :-/ And this isnt bikeshed-painting really,
> >> the RNGBF_ name hurts my eyes and RB_ is definitely confusing to read.
> >> (as the rbtree constants are in capitals as well and similarly named)
> >>
> >>  RING_TYPE_PADDING
> >>
> >> or:
> >>
> >>  RINGBUF_TYPE_PADDING
> >>
> >> yes, it's longer, but still, saner.
> >
> > I don't mind the extra typing, it is just a bit more difficult to keep in
> > the 80 character line limit.
> 
> Would using tb_ (trace buffer) rather than rb_ help ?

excellent idea ...

	Ingo
