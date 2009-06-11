Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbZFKK0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbZFKK0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761897AbZFKK00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:26:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083AbZFKK0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:26:25 -0400
Date: Thu, 11 Jun 2009 12:26:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing/urgent for v2.6.31
Message-ID: <20090611102620.GB31719@elte.hu>
References: <20090610230450.GA8964@elte.hu> <alpine.LFD.2.01.0906102002260.6847@localhost.localdomain> <alpine.DEB.2.00.0906102327050.30552@gandalf.stny.rr.com> <alpine.LFD.2.01.0906102045420.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906102045420.6847@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 10 Jun 2009, Steven Rostedt wrote:
> > 
> > Well it was:
> > 
> > 	default y if DEBUG_KERNEL
> > 
> > Where the rational was that if you want to debug the kernel, you 
> > might want to see some tracing features that are available to 
> > you.
> 
> Sure. I think that FTRACE config is borderline fine, although I 
> think tracing is pretty different from the debug options that 
> don't need the user to actually do anything (like 
> PAGEALLOC_DEBUG).
> 
> It's the other ones I think were clearly dubious (ok, the MARKERS 
> one isn't "clearly" dubious, since I have no idea why it got 
> enabled, so I guess it would count as "unclearly dubious" then).

I agree that we have too many default-y options - we'll have a sweep 
of all options and will default-disable the dubious (and unclearly 
dubious) ones in a way that truly re-triggers user selection even if 
the option is already enabled in the .config.

This particular new menu didnt actually change any of the existing 
options or defaults: it just organized/grouped an already existing, 
somewhat disorganized set of options and made it easier to disable 
them summarily. Making _that_ default-n could have caused people to 
accidentally disable a lot of options they had enabled in their 
configs intentionally.

	Ingo
