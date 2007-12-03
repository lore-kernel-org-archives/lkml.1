Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXLCQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXLCQss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXLCQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:48:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXLCQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:48:40 -0500
Date: Mon, 3 Dec 2007 17:47:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org
Subject: Re: [PATCH] isapnp driver semaphore to mutex
Message-ID: <20071203164751.GB16135@elte.hu>
References: <20071203153743.119714913@mvista.com> <20071203155753.GA32546@elte.hu> <1196697144.1568.1.camel@jnielson-xp.ddns.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196697144.1568.1.camel@jnielson-xp.ddns.mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Daniel Walker <dwalker@mvista.com> wrote:

> On Mon, 2007-12-03 at 16:57 +0100, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > Changed the isapnp semaphore to a mutex.
> > 
> > cool - i'll give it a whirl.
> > 
> > small immaterial nit:
> > 
> > > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > 
> > it's Signed-off-by (note the capitalization). Having this consistent 
> > makes scripting around patches a tiny bit easier.
> 
> Yeah, I know about it but sometimes still slips by..

it's worth automating these repetative bits. I use small templates when 
creating patches. Also, it's worth running patches through 
scripts/checkpatch.pl - it has a check for exactly this typo. [ Not a 
big issue at all, i just mentioned it in case you get a taste for 
sending more sem2mutex patches :-) ]

	Ingo
