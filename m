Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZJNHBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZJNHBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZJNHBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:01:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbZJNHBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:01:08 -0400
Date: Wed, 14 Oct 2009 08:59:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Message-ID: <20091014065941.GH784@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu> <200910131952.01209.elendil@planet.nl> <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain> <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> On Tue, 13 Oct 2009, Linus Torvalds wrote:
> 
> > > IMHO yes. This change essentially creates a backwards incompatibility with 
> > > existing naming schemes. Requiring to patch the change out to preserve an 
> > > existing naming scheme just seems a tad unfriendly.
> > 
> > Let's keep the old behavior by making the AUTO option an three-way 
> > choice ("none", "short", "auto"), and making sure that it actually 
> > takes work to choose "none" (and that "make oldconfig" doesn't 
> > choose it unless you explicitly made the choice before - so people 
> > who just re-use old .config files wouldn't get "none" by mistake).
> 
> I don't think you want to do that because it would require the .config 
> to be posted on bug reports, for example, to determine the setting of 
> CONFIG_LOCALVERSION_AUTO before you can interpret the kernel version.  
> In other words, you wouldn't know that "2.6.32-rc4" is actually 200 
> commits beyond the actual release unless you also know that the 
> .config has CONFIG_LOCALVERSION_AUTO="none".

We've come a full circle ...

That's the current !CONFIG_LOCALVERSION_AUTO status quo ... That was 
being asked to be preserved for (unspecified) packaging reasons. So
your suggestion is to do away with that behavior altogether?

	Ingo
