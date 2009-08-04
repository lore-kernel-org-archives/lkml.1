Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbZHDI4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbZHDI4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbZHDI4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:56:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35172 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbZHDI4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:56:20 -0400
Date: Tue, 4 Aug 2009 10:56:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] perf tools: allow top users to switch between weighted
	and individual counter display
Message-ID: <20090804085615.GA25862@elte.hu>
References: <1248422990.28486.3.camel@marge.simson.net> <1248425937.6987.0.camel@twins> <1248431821.9722.4.camel@marge.simson.net> <20090802200049.GF24486@elte.hu> <1249276178.17959.67.camel@marge.simson.net> <1249374083.10069.18.camel@marge.simson.net> <20090804083219.GA18081@elte.hu> <1249375572.10642.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249375572.10642.3.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2009-08-04 at 10:32 +0200, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Mon, 2009-08-03 at 07:09 +0200, Mike Galbraith wrote:
> > > 
> > > > Not sure I like waiting for input at start though, maybe just 
> > > > display and sleep a couple seconds would be friendlier.
> > > 
> > > I find both really annoying, so just go straight into displaying.  
> > > That kind of usage information belongs in the man page.  I've 
> > > updated same to reflect the current implementation, and will 
> > > submit separately.
> > 
> > yeah - will apply both patches, thanks Mike.
> 
> Thanks.
> 
> > I'm wondering, have you seen the 'tig' tool before? It puts the 
> > console into raw mode too and has a rather pleasant text interface. 
> > Since it's a relatively young project it might have a compact code 
> > base that could be imported (assuming the license is compatible and 
> > assuming what i say is true - have not checked yet).
> 
> No, I haven't.  I'll take a look (time time time) though, because 
> I'd like to make top fully interactive, and my code is... um er, 
> somewhat crude :)

it's at:

  git clone http://jonas.nitro.dk/tig/tig.git

7 KLOC and clean looking. Code seems quite readable and in standard 
Git style - i.e. kernel and tools/perf/ compatible. License is GPLv2 
or later - i.e. that too is kernel compatible.

The tig.c is a bit large at 7000+ lines, but it looks easily split. 
It uses libcurses for console handling.

Looks like a pretty good starting point IMO.

	Ingo
