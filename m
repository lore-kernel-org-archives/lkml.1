Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZFPKNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZFPKNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZFPKMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:12:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbZFPKMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:12:48 -0400
Date: Tue, 16 Jun 2009 12:12:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616101240.GB28204@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616110419.14bc9485@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >  stack-trace entries:                262144 [max: 262144]
> > 
> > stack-trace entries ran out. And it seems like you didnt quadruple 
> > MAX_STACK_TRACE_ENTRIES to 1 million entries.
> 
> I did a while ago but would have been another kernel config.
> 
> > Do we run out of entries right during bootup? Are you 
> > loading/unloading modules a lot perhaps? Could you send your 
> > .config please? (assuming a plain bootup triggers it - that 
> > should make it reproducible to me too)
> 
> On bootup with a totally generic Fedora 11, thinkpad setup with 
> the kernel swapped for current git head. Will send the .config off 
> list and build it with a 1M entry stack trace again.

Nah, dont waste your time on that for now - if it's reproducible on 
simple bootup then i will be able to trigger it once i have your 
config.

Thanks,

	Ingo
