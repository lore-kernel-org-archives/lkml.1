Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbXFANDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbXFANDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXFANDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:03:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbXFANDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:03:11 -0400
Date: Fri, 1 Jun 2007 15:03:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
Message-ID: <20070601130302.GA16172@elte.hu>
References: <46600F1C.5000302@googlemail.com> <E1Hu6k5-0001Xm-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hu6k5-0001Xm-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > Subject    : long freezes on thinkpad t60
> > References : http://lkml.org/lkml/2007/5/24/100
> > Submitter  : Miklos Szeredi <miklos@szeredi.hu>
> > Handled-By : Ingo Molnar <mingo@elte.hu>
> > Status     : problem is being debugged
> 
> This isn't a regression strictly speaking, as 2.6.21 is known to be 
> affected, and older kernels might also be.
> 
> It's non-fatal and only happens under very special circumstances, so 
> it's definitely not a showstopper.
> 
> I don't mind being bugged about this once in a while, this is just for 
> clarification.

i have no better ideas that what you already tried - but unfortunately 
the tracer makes the bug go away and the NMI watchdog crashes your box. 
Btw., nmi_watchdog=2 might have a higher chance of surviving (it can 
still lock up a T60 but with a lower likelyhood).

	Ingo
