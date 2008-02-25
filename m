Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYBYM5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYBYM5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 07:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYBYM5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 07:57:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44634 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbYBYM53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:57:29 -0500
Date: Mon, 25 Feb 2008 13:57:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225125707.GA27202@elte.hu>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu> <20080225110858.GA32450@cs181133002.pp.htv.fi> <20080225111707.GA7062@elte.hu> <20080225113235.GC32450@cs181133002.pp.htv.fi> <20080225115022.GA16376@elte.hu> <20080225122526.GE32450@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225122526.GE32450@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> > the existing 32-bit and 64-bit defconfigs should be enough for that. 
> > For better/full coverage, randconfig should be used.
> 
> The two big problems with randconfigs are:
> - either you build each .config both with and without your patch or you
>   have to manually check which of the failures are caused by your patch
> - you require at least an order of magnitude more builds for having the
>   same amount of common configurations covered
> 
> And any solution that only works on x86 (e.g. based on the expectation 
> that all randconfig configurations normally build) is of zero value 
> for me since x86 is only one out of 23 architectures.

so if an arguably sane testing method "only" works on x86 then the right 
solution is to fix the other architectures to be sanely testable too. 
I've seen architectures that were build-tested for the _first time_ at 
around 2.6.24-rc8...

	Ingo

