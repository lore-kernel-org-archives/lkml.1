Return-Path: <linux-kernel-owner+w=401wt.eu-S1764156AbXHFLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764156AbXHFLu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763028AbXHFLuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:50:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXHFLuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:50:12 -0400
Date: Mon, 6 Aug 2007 13:49:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gregory Haskins <ghaskins@novell.com>, Daniel Walker <dwalker@mvista.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
Message-ID: <20070806114954.GC1903@elte.hu>
References: <1185992994.2636.142.camel@imap.mvista.com> <20070801201802.GA225@tv-sign.ru> <1186000468.2636.168.camel@imap.mvista.com> <20070801205053.GA263@tv-sign.ru> <1186002783.9513.228.camel@ghaskins-t60p.haskins.net> <20070801213422.GA280@tv-sign.ru> <1186005598.9513.261.camel@ghaskins-t60p.haskins.net> <20070801222201.GA316@tv-sign.ru> <1186012439.9513.321.camel@ghaskins-t60p.haskins.net> <20070802195049.GA361@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802195049.GA361@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 08/01, Gregory Haskins wrote:
> >
> > On Thu, 2007-08-02 at 02:22 +0400, Oleg Nesterov wrote:
> > 
> > > No,
> > 
> > You sure are a confident one ;)
> 
> Yeah, this is a rare case when I am very sure I am right ;)
> 
> I strongly believe you guys take a _completely_ wrong approach. 
> queue_work() should _not_ take the priority of the caller into 
> account, this is bogus.

Oleg, i'd like to make it sure that the role of Gregory Haskins is clear 
here: he submitted some new infrastructure into the -rt tree, and i 
reviewed that but found it quite complex and duplicative and suggested 
him to think about enhancing workqueues with priority properties - which 
might or might not make sense.

It is not the intention of the -rt project to pester any upstream 
maintainer with -rt issues if that upstream maintainer is not interested 
in it ... so please just forget about all this if you are not interested 
in it, we'll sort it out within -rt. Thanks,

	Ingo

