Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZFPIur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZFPIur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZFPIuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:50:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZFPIuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:50:39 -0400
Date: Tue, 16 Jun 2009 10:50:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616085028.GA13771@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 16 Jun 2009 01:45:36 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > [ Ingo and Andrew, sorry for the repost, but I forgot to Cc LKML and I 
> >   also used Alan's old email. ]
> > 
> > I can easily trigger a bug in the tty code by enabling the event 
> > tracers.
> 
> Yes I know. I sent Linus a temporary workaround yesterday. The bug 
> is as old as the hills (the race in various forms predates any git 
> or bk history!). The ldisc changes happened to make it more 
> visible.
>
> Unfortunately its non trivial to fix but the workaround should 
> make it as hard to hit now as in 2.6.30 while I sort the funnies 
> out. Really though I need the lock verifier working to do that, 
> and its been busted since 2.6.30 8(

Hm, have you tried the patch i sent to you that extends the 
number-lock-locks-tracked limit you have run into? It is trivial.

	Ingo
