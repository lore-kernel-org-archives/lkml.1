Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYABMZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYABMZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYABMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:25:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44818 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbYABMZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:25:32 -0500
Date: Wed, 2 Jan 2008 13:19:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080102121909.GA6285@elte.hu>
References: <9DtBq-2jD-3@gated-at.bofh.it> <200801022131.15482.nickpiggin@yahoo.com.au> <1199271676.6821.112.camel@twins> <200801022212.29303.nickpiggin@yahoo.com.au> <1199273047.6821.119.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199273047.6821.119.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> >  It would be sweet to have them use private mutexes for the job 
> > instead (although even then it probably wouldn't be a straight 
> > conversion)...
> 
> I tried a quick conversion of reiser3 at the time, but it really wants 
> a recursive lock and I couldn't be bothered to fix a 'legacy' 
> filesystem so I just gave up and converted the filesystem to XFS.

as long as the only requirement is recursion, and not any of the other 
BKL properties, that could be wrapped. I guess fixing the TTY code to 
have no BKL dependencies has a higher chance of success - given that 
Alan is working on it :-)

	Ingo
