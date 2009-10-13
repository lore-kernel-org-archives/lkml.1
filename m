Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbZJMHGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbZJMHGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZJMHGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:06:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbZJMHF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:05:59 -0400
Date: Tue, 13 Oct 2009 09:05:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Message-ID: <20091013070505.GC31483@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <200910130004.46388.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200910130004.46388.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> On Monday 12 October 2009, Ingo Molnar wrote:
> > It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
> > way:
> >
> >  - if it is set, things work the way they always have, and you get a
> >    extended kernel release like:
> >
> >         2.6.32-rc3-00052-g0eca52a
> >
> >  - but if it is _not_ set, we'll still try to get a version from the
> >    underlying SCM (we actually support git, hg and SVN right now, even
> > if some comments may say "git only"), and if the underlying SCM says it
> > has a local version, we append just "+", so you get a version number
> > like:
> >
> >         2.6.32-rc3+
> 
> I don't object to making this the default (even a strong default), but 
> I still don't like the fact that it's not optional.
>
> IMO both LOCALVERSION_AUTO *and* the added "+" can be unsuitable for 
> some use cases, for example for distributions.
> 
> If someone uses git to manage their custom patches, the only out this 
> patch leaves them to avoid the "+" is to revert it in their own trees.

Is this a bad thing?

> IMO that should not be necessary.

Why not?

	Ingo
