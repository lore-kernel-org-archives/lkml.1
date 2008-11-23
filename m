Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbYKWVjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbYKWVjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYKWVjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:39:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYKWVjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:39:35 -0500
Date: Sun, 23 Nov 2008 22:38:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
Message-ID: <20081123213855.GB16613@elte.hu>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <87iqqei5ys.fsf@basil.nowhere.org> <alpine.DEB.1.10.0811231455090.13888@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811231455090.13888@gandalf.stny.rr.com>
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

> On Sun, 23 Nov 2008, Andi Kleen wrote:
> > Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > > This adds a significant amount of overhead and should only be 
> > > used by those analyzing their system.
> > 
> > Often this can be also done using CPU performance counters. Might 
> > be a cheaper option.
> 
> I'd love to add an option that could hook into any arch with HW 
> support for this. We could dump out the same information, but just a 
> different way to gather it.  But I'm still ignorant to the use of 
> CPU performance counters and how to find which branch matches which 
> if.

there's already new ftrace code for this and the patches are done - 
stay tuned.

but it wont be a replacement for the soft method (which is more 
flexible - the hw can only do 'all or nothing' type of branch 
tracing), so it's complementary.

	Ingo
