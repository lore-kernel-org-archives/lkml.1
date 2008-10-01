Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYJAHXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYJAHXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYJAHXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:23:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYJAHXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:23:23 -0400
Date: Wed, 1 Oct 2008 09:23:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/2] ring_buffer: updates for linux-tip
Message-ID: <20081001072300.GD9366@elte.hu>
References: <20081001042951.412019606@goodmis.org> <c62985530810010020u1f3f44e1l6b8fb2f31c35d215@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810010020u1f3f44e1l6b8fb2f31c35d215@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/1 Steven Rostedt <rostedt@goodmis.org>:
> > The first patch is just a lockdep clean up of the ring buffer.
> >
> > The next patch is a new locking design. It is not lockless (yet) but
> > the locking is a bit cleaner than the original. The basic idea is
> > that the reader now has its own page to read from that is not in
> > the ring buffer. When the reader (a consumer) finishes a page, it
> > then grabs a lock to pull out a new page from the ring buffer and
> > replace it with the one that it just finished reading.
> 
> Good idea! Sounds a real saner approach.

are the tracer problems you've reported yesterday fixed in latest 
tip/master?

	Ingo
