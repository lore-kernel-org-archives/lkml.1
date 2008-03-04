Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYCDOXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYCDOXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYCDOXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:23:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYCDOXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:23:08 -0500
Date: Tue, 4 Mar 2008 15:22:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080304142248.GA2201@elte.hu>
References: <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303120211.GG4457@cs181133002.pp.htv.fi> <20080303121015.GA12660@elte.hu> <20080303122953.GH4457@cs181133002.pp.htv.fi> <20080303125027.GA21577@elte.hu> <20080303145413.GA26072@cs181133002.pp.htv.fi> <20080304131600.GG29777@elte.hu> <20080304134701.GA20278@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304134701.GA20278@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Tue, Mar 04, 2008 at 02:16:00PM +0100, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > > well, i'm trying to assume the best, so please explain the following 
> > > > sequence of events to me:
> > > > 
> > > > 1) as you said you knew about this bug - which bug causes more inlining
> > > >    overhead than hundreds of your uninlining patches combined. The bug
> > > >    was introduced ~2 years ago in -mm - before the feature hit mainline
> > > >    in v2.6.16.
> > > 
> > > I don't remember having ever said this.
> > > 
> > > Your choices are:
> > > [ ] prove your accusation that I said I
> > >     "knew about this bug before the feature hit mainline"
> > > [ ] apologize
> > > [ ] be the firest person ever in my killfile
> > 
> > Adrian, you must be misunderstanding something. Where exactly in the 
> > above sentences do i assert that you "knew about this bug before the 
> > feature hit mainline"? I dont say that and cannot say that -
> 
> Please explain your statement "before the feature hit mainline in 
> v2.6.16" in the above sentence of you in a reasonable way other than 
> that it should say I knew about it before the feature hit mainline.

do you mean this paragraph:

| 1) as you said you knew about this bug - which bug causes more 
| inlining overhead than hundreds of your uninlining patches combined. 
| The bug was introduced ~2 years ago in -mm - before the feature hit 
| mainline in v2.6.16.

sorry, but i know of no rule of grammar that could read your 
interpretation into my two sentences.

(and that's not surprising at all, because i never intended to even 
suggest that you knew about this breakage "before it went mainline" - 
why would i even care about such a detail?)

	Ingo
