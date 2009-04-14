Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZDNOGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZDNOGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZDNOGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:06:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbZDNOGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:06:33 -0400
Date: Tue, 14 Apr 2009 16:04:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090414140416.GE27163@elte.hu>
References: <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <alpine.DEB.1.10.0904012216370.32656@qirst.com> <20090402034223.GA25791@elte.hu> <alpine.DEB.1.10.0904020948570.31756@qirst.com> <20090408162651.GA14449@elte.hu> <alpine.DEB.1.10.0904131409510.13756@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904131409510.13756@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Wed, 8 Apr 2009, Ingo Molnar wrote:
> 
> > Dude, this is a new facility freshly modernized and freshly made
> > usable. What did you expect, for a thousand usecases pop up in the
> > kernel overnight? _None_ of this code is "common" today per se. (the
> > networking folks are working on making it more and more common
> > though)
> 
> ?? kfree(NULL) has been allowed for years. None of this is new.

[ This reply if yours is completely inapposite. It does not fit into 
  the logical stream of arguments at all. Of course kfree(NULL) has 
  been allowed for years. Did i claim otherwise? I dont think you
  understand my arguments - and i get the impression that you dont
  even _try_ to understand them. ]

The thing is, i spent well in excess of an hour analyzing your 
patch, counting cachelines, looking at effects and interactions, 
thinking about the various implications. I came up with a good deal 
of factoids, a handful of suggestions and a few summary paragraphs:

  http://marc.info/?l=linux-kernel&m=123862536011780&w=2

A proper reply to that work would be one of several responses:

  1) to ignore it. (you can always do that, you dont have to react
     to everything on lkml - especially if you think it's bull.)

  2) disagree with the factoids - preferably in a specific way.

  3) agree with the factoids and disagree with my opinion.

  4) agree with it all.

You did neither of these: you never replied to my detailed analysis, 
you only replied to my followup summary - disagreeing with my 
opinion based not on a fair deconstruction of my factoids but on a 
mere repetition of your arguments.

Furthermore, you also tried to 'win' this argument by increasing the 
volume of shouting, by injecting unprovoked insults and by using a 
patronizing and irritated tone.

You might be completely right in the end technically (i fully submit 
that the discussion is open-ended), but this kind of generic 
handwaving and your asocial behavior in this thread does not really 
do your technical arguments any service. It can only really end in 
me starting to ignore you.

	Ingo
