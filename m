Return-Path: <linux-kernel-owner+w=401wt.eu-S1161252AbXCNMxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161252AbXCNMxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161255AbXCNMxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:53:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161252AbXCNMxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:53:51 -0400
Date: Wed, 14 Mar 2007 13:53:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314125330.GA13168@elte.hu>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73slc8863r.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > So I spent last night hacking up something to try to make a common 
> > ground for all code that is shared between x86_64 and i386.  I 
> > called this
> > 
> >    arch/x86
> 
> NACK. I think the current ways work just fine.

i agree. We've recently factored out quite a bit of common code between 
i386 and x86_64 recently: genirq, gtod/clocksource and clockevents.

and that's how i think unification of architectures should be done: move 
code into kernel/* and drivers/*, _not_ into another architecture. That 
way all architectures benefit.

	Ingo
