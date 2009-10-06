Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZJFSuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZJFSuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZJFSuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:50:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111AbZJFSuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:50:12 -0400
Date: Tue, 6 Oct 2009 20:49:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] kbuild: Improve version string logic
Message-ID: <20091006184911.GA833@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <1254854227.22426.37.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254854227.22426.37.camel@johannes.local>
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2009-10-06 at 19:35 +0200, Ingo Molnar wrote:
> 
> > It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
> > way:
> > 
> >  - if it is set, things work the way they always have, and you get a
> >    extended kernel release like:
> > 
> > 	2.6.32-rc3+00052-g0eca52a-dirty
> > 
> >    ( with the difference that the extra version string is separated via
> >      '+' not via '-'. This improves visibility when we have additional
> >      changes over a vanilla tag. )
> 
> I really don't see how it improves visibility (unless you're oblivious 
> to the difference between long and short strings), but I do know that 
> I have a few parsers that this will break.

It improves visibility the same way the + at the end of the short 
version improves visibility.

That said, i'm perfectly fine with just having the short version include 
the '+' sign (i.e. Linus's original patch), that was my original 
suggestion and that is already a big step forward.

Thanks,

	Ingo
