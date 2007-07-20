Return-Path: <linux-kernel-owner+w=401wt.eu-S933395AbXGTTaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbXGTTaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760619AbXGTTaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:30:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760093AbXGTTaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:30:19 -0400
Date: Fri, 20 Jul 2007 21:30:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] slub crashes with recent -git
Message-ID: <20070720193008.GA4190@elte.hu>
References: <20070719194234.GA27917@elte.hu> <1184952874.12655.4.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184952874.12655.4.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> On Thu, 2007-07-19 at 21:42 +0200, Ingo Molnar wrote:
> > Linus, Christoph,
> > 
> > recent slub commits in -git cause this bootup crash:
> > 
> >  Freeing unused kernel memory: 324k freed
> >  Write protecting the kernel read-only data: 1294k
> 
> Just curious, are the crashes even possible in 2.6.22.1? (I see the 
> same patchable code snippet in the source). Just wondering if I should 
> also apply this to 2.6.21.1-rt4...

no, i think they are unique to .23, due to the recent stricter behavior 
introduced for zero-sized allocs.

	Ingo
