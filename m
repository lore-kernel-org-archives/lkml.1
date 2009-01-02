Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbZABWIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbZABWIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbZABWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:08:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZABWI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:08:27 -0500
Date: Fri, 2 Jan 2009 23:08:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Indan Zupancic <indan@nul.nu>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race in ring_buffer_consume(): Replace
	ring_buffer_consume and ring_buffer_peek with ring_buffer_get_event
Message-ID: <20090102220818.GD17240@elte.hu>
References: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl> <1230536044-14847-1-git-send-email-indan@nul.nu> <20081229122449.GG9628@elte.hu> <57128.124.177.22.144.1230786624.squirrel@secure.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57128.124.177.22.144.1230786624.squirrel@secure.greenhost.nl>
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


* Indan Zupancic <indan@nul.nu> wrote:

> On Mon, December 29, 2008 13:24, Ingo Molnar wrote:
> >
> > * Indan Zupancic <indan@nul.nu> wrote:
> >
> >> Original mail was mangled, patch resent via git.
> >>
> >> Signed-off-by: Indan Zupancic <indan@nul.nu>
> >> ---
> >>  include/linux/ring_buffer.h   |    4 +---
> >>  kernel/trace/ring_buffer.c    |   39
> >> ++++++++-------------------------------
> >>  kernel/trace/trace.c          |   15 ++++++++-------
> >>  kernel/trace/trace_selftest.c |    2 +-
> >>  4 files changed, 18 insertions(+), 42 deletions(-)
> >
> > there's been a number of updates here - could you please do a patch
> > against tip/master:
> >
> >   http://people.redhat.com/mingo/tip.git/README
> 
> Thanks for that readme, now I discovered git remote, which is not
> mentioned often enough for some reason.
> 
> A lot changed indeed, most importantly the race that I hit is
> fixed in tip by improved locking. Replace ring_buffer_consume()
> and ring_buffer_peek() with ring_buffer_get_event() or not is
> just a matter of taste now. Are you still interested in such a
> patch?

the code gets simpler and more readable, so why not? Steve, any 
objections?

> (34 EXPORT_SYMBOL_GPLs in ring_buffer.c seems a bit excessive though.)

agreed.

	Ingo
