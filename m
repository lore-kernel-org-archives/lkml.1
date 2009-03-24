Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbZCXOQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbZCXOQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZCXOHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:07:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbZCXOHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:07:07 -0400
Date: Tue, 24 Mar 2009 15:06:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324140642.GE32043@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324133542.GA29046@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324133542.GA29046@gondor.apana.org.au>
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

> On Tue, Mar 24, 2009 at 02:02:02PM +0100, Ingo Molnar wrote:
> > 
> > Yesterday about half of my testboxes (3 out of 7) started getting 
> > weird networking failures: their network interface just got stuck 
> > completely - no rx and no tx at all. Restarting the interface did 
> > not help.
> 
> Darn, does this patch help?
> 
> net: Fix netpoll lockup in legacy receive path

thanks, added it to the test mix. Should know the result fin 1-2 
hours test time.

	Ingo
