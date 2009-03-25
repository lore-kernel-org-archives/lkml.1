Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbZCYJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbZCYJfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758943AbZCYJfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:35:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758900AbZCYJfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:35:30 -0400
Date: Wed, 25 Mar 2009 10:34:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325093456.GE2341@elte.hu>
References: <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325002303.GA2219@gondor.apana.org.au>
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

> On Tue, Mar 24, 2009 at 02:36:22PM -0700, David Miller wrote:
> >
> > I think the problem is that we need to do the GRO flush before the
> > list delete and clearing the NAPI_STATE_SCHED bit.
> 
> Well first of all GRO shouldn't even be on in Ingo's case, unless
> he enabled it by hand with ethtool. [...]

i didnt. (But it's randconfig - so please have a good look at all 
.config details - maybe something has an unexpected side-effect?)

	Ingo
