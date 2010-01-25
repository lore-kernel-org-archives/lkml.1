Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642Ab0AYSCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0AYSCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619Ab0AYSCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:02:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41826 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461Ab0AYSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:02:39 -0500
Date: Mon, 25 Jan 2010 18:03:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: rostedt@goodmis.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100125180315.6bcb347f@lxorguk.ukuu.org.uk>
In-Reply-To: <1264442070.31321.422.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	<20100122221348.GA4263@redhat.com>
	<alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	<alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	<f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	<20100123112333.GA15455@elte.hu>
	<20100123114729.GA7828@redhat.com>
	<20100123194820.GM21263@thunk.org>
	<f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
	<alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
	<20100125170254.GB22862@redhat.com>
	<alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
	<1264442070.31321.422.camel@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Uh oh, that's not good for us real-time folks.
> 
> http://lwn.net/Articles/357800/
> 
> "And, according to Linus, the realtime people are crazy, so they can be
> left to deal with the weird stuff."

	I'd prefer the trees to be separate for testing purposes: it 
	doens't	make much sense to have SMP support as a normal
	kernel feature when most people won't have SMP anyway"
			-- Linus Torvalds


Use cases got that into the tree pretty easily, I am sure RT ones will do
the same.
