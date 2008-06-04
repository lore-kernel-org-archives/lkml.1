Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYFDAmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYFDAmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYFDAmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:42:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38557 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752544AbYFDAmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:42:04 -0400
Date: Tue, 3 Jun 2008 19:41:48 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: ioe-lkml@rameria.de, sivanich@sgi.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@kolivas.org, dfults@sgi.com,
       devik@cdi.cz, dino@in.ibm.com, emmanuel.pacaud@univ-poitiers.fr,
       deweerdt@free.fr, mingo@elte.hu, colpatch@us.ibm.com,
       nickpiggin@yahoo.com.au, rostedt@goodmis.org, oleg@tv-sign.ru,
       paulmck@us.ibm.com, menage@google.com, rddunlap@osdl.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
Message-Id: <20080603194148.56dfebe1.pj@sgi.com>
In-Reply-To: <4845D825.6000403@qualcomm.com>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<48447C75.8040203@qualcomm.com>
	<200806030156.00155.ioe-lkml@rameria.de>
	<4844BB41.7000605@qualcomm.com>
	<4845D825.6000403@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> So I expect two ACKs for isolcpu= removal from both of you, in bold please :)

Not from me, anyway.

I've seen enough replies (thanks!) from users of isolcpus=
to be quite certain that we should not just remove it outright.

I will NAQ such proposals.

And until, and unless, someone comes up with a persuasive answer
to Nick's question:

> is there a real reason _to_ remove it?

I'll probably NAQ proposals to deprecate it as well.

Max ... I think one place where you and I disagree is on whether
it is a good idea to have multiple ways to accomplish the same
thing.

As Ingo Oeser pointed out:
> The initrd is from the distribution. I have no sane way to change it

Even if you do find a way that seems sane to you, that's not the point,
in my view.  Further, given the constraints on producing product that
will fit in with multiple distributions, I doubt that the alternatives
you suggest to Info Oeser would work well for him anyway.

A key reason that Linux has succeeded is that it actively seeks to work
for a variety of people, purposes and products.  One operating system is
now a strong player in  the embedded market, the real time market, and
the High Performance Computing market, as well as being an important
player in a variety of other markets.  That's a rather stunning success.

If you went to your local grocery store with your (if you have one)
young child, and found that they had no Lucky Charms breakfast cereal
(your childs favorite) you would not be pleased if the store manager
tried to sell you Fruit Loops instead ... just as much sugar and food
coloring.

If we have features that seem to duplicate functionality, in a
different way, and that aren't causing us substantial grief to
maintain, and that aren't significantly hurting our performance or
robustness or security or seriously getting in the way of further
development, then we usually leave those features in.

Please understand, Max, that for every kernel hacker working in this
corner of the Linux kernel, there are a hundred or a thousand users
depending on what we do, and who will have to adapt to any incompatible
changes we make.  If we save ourselves an hour by removing "unnecessary"
features, we can cost a hundred others each some time adapting to this
change.  A few of those others may get hit for substantial effort, if
the change catches them unawares at the wrong time and place.

As good citizens of the universe, we should seek to optimize the
aggregate effort we spend to obtain a particular level of quality and
functionality.

Saving yourself an hour while you cost a hundred others ten minutes
each is not a net gain.  Sometimes this means not enforcing a "one way,
and one way only, to do any given task." I wouldn't go as far as Perl
does in this regard, but we do run a more polyglot product than say
Python.

Try thinking a little more like a WalMart product manager than a
Ferrari designer.  If it is currently selling to our customers, and if
we can fit it into our supply and distribution chain, and if we can
continue to make an adequate profit per foot of shelf space, then
continue to buy it, stock it, ship it, and sell it.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
