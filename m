Return-Path: <linux-kernel-owner+w=401wt.eu-S1761711AbZCXPgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761711AbZCXPgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbZCXPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:36:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbZCXPgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:36:45 -0400
Date: Tue, 24 Mar 2009 16:36:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324153616.GA31143@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324150928.GB30224@gondor.apana.org.au>
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


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Tue, Mar 24, 2009 at 03:39:42PM +0100, Ingo Molnar wrote:
> >
> > Subject: [PATCH] net: Fix netpoll lockup in legacy receive path
> 
> Actually, this patch is still racy.  If some interrupt comes in
> and we suddenly get the maximum amount of backlog we can still
> hang when we call __napi_complete incorrectly.  It's unlikely
> but we certainly shouldn't allow that.  Here's a better version.
> 
> net: Fix netpoll lockup in legacy receive path

ok - i'm testing with this now.

	Ingo
