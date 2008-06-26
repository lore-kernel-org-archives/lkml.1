Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbYFZLjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbYFZLjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYFZLjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:39:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53615 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbYFZLjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:39:06 -0400
Date: Thu, 26 Jun 2008 13:38:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
	__GFP_NORETRY
Message-ID: <20080626113855.GE29619@elte.hu>
References: <20080526234940.GA1376@xs4all.net> <1212682484.4332.7.camel@n2o.xs4all.nl> <20080610102347.GC19136@elte.hu> <200806101014.25089.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806101014.25089.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tuesday, June 10, 2008 3:23 am Ingo Molnar wrote:
> > * Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> > > On Mon, 2008-06-02 at 12:15 +0200, Ingo Molnar wrote:
> > > > * Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> > > > > Okay, so how about this then ?
> > > >
> > > > applied to tip/pci-for-jesse for more testing. Thanks,
> > >
> > > I've thought about it a bit more, and I think the actual patch that
> > > really does what everybody wants is this one instead:
> >
> > applied a delta patch version of the one below to tip/pci-for-jesse.
> 
> Speaking of that branch, how do you want to handle it?  Is it intended 
> for my linux-next branch or are some of the fixes important to get 
> upstream now?  Which branch should I diff/log against to see the 
> changes (last time I looked it appeared neither master nor tip were 
> the correct ones...)

that branch is always based in -git so if stuff goes upstream patches 
disappear from it. git-log linus/master..tip/pci-for-jesse should tell 
the currently pending items. Right now it's just two lowprio items:

 Yinghai Lu (2):
      pci: debug extra pci resources range
      pci: debug extra pci bus resources

	Ingo
