Return-Path: <linux-kernel-owner+w=401wt.eu-S937069AbXGSNCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937069AbXGSNCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763202AbXGSNBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:01:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:46234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763089AbXGSNBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:01:52 -0400
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
References: <20070715.210036.157242351.takada@mbf.nifty.com>
	<200707191052.50047.juergen127@kreuzholzen.de>
	<200707191125.47079.ak@suse.de>
	<200707191225.26047.juergen127@kreuzholzen.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Jul 2007 15:56:51 +0200
In-Reply-To: <200707191225.26047.juergen127@kreuzholzen.de>
Message-ID: <p73ir8gwl7g.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Beisert <juergen127@kreuzholzen.de> writes:

> Hi Andi,
> 
> On Thursday 19 July 2007 11:25, Andi Kleen wrote:
> > On Thursday 19 July 2007 10:52:48 Juergen Beisert wrote:
> > > On Thursday 19 July 2007 10:22, Andi Kleen wrote:
> > > > > Wow, that's a really cool bug; nice work!  Don't forget to update
> > > > > arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.
> > > > >  It needs to include processor-cyrix.h.
> > > >
> > > > It also needs some big fat comments
> > >
> > > No problem. Where to add?
> >
> > Where the inlines are defined.
> >
> > Also can you please resubmit full patches with full description
> > and Signed off lines, not incrementals? Thanks.
> 
> Find attached. Hope its ok now.

For future reference:
- Please send the patches inline if possible
- Generate them from top level (so path start with linux...) 

I fixed it all up

-Andi
