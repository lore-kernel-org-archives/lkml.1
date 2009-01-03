Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbZACXzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbZACXzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZACXz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:55:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZACXz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:55:27 -0500
Subject: Re: [PATCH] Fix race in ring_buffer_consume(): Replace
	ring_buffer_consume and ring_buffer_peek with ring_buffer_get_event
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Indan Zupancic <indan@nul.nu>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090102220818.GD17240@elte.hu>
References: <54882.124.179.251.206.1230523141.squirrel@secure.greenhost.nl>
	 <1230536044-14847-1-git-send-email-indan@nul.nu>
	 <20081229122449.GG9628@elte.hu>
	 <57128.124.177.22.144.1230786624.squirrel@secure.greenhost.nl>
	 <20090102220818.GD17240@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Sat, 03 Jan 2009 18:55:17 -0500
Message-Id: <1231026917.15476.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-01-02 at 23:08 +0100, Ingo Molnar wrote:
> * Indan Zupancic <indan@nul.nu> wrote:
> 
> > On Mon, December 29, 2008 13:24, Ingo Molnar wrote:
> > >
> > > * Indan Zupancic <indan@nul.nu> wrote:
> > >
> > >> Original mail was mangled, patch resent via git.
> > >>
> > >> Signed-off-by: Indan Zupancic <indan@nul.nu>
> > >> ---
> > >>  include/linux/ring_buffer.h   |    4 +---
> > >>  kernel/trace/ring_buffer.c    |   39
> > >> ++++++++-------------------------------
> > >>  kernel/trace/trace.c          |   15 ++++++++-------
> > >>  kernel/trace/trace_selftest.c |    2 +-
> > >>  4 files changed, 18 insertions(+), 42 deletions(-)
> > >
> > > there's been a number of updates here - could you please do a patch
> > > against tip/master:
> > >
> > >   http://people.redhat.com/mingo/tip.git/README
> > 
> > Thanks for that readme, now I discovered git remote, which is not
> > mentioned often enough for some reason.
> > 
> > A lot changed indeed, most importantly the race that I hit is
> > fixed in tip by improved locking. Replace ring_buffer_consume()
> > and ring_buffer_peek() with ring_buffer_get_event() or not is
> > just a matter of taste now. Are you still interested in such a
> > patch?
> 
> the code gets simpler and more readable, so why not? Steve, any 
> objections?

I'd like to look closer at this code on Monday.

Thanks,

-- Steve


