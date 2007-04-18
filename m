Return-Path: <linux-kernel-owner+w=401wt.eu-S2992744AbXDRVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992744AbXDRVQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992747AbXDRVQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:16:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992744AbXDRVQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:16:45 -0400
Date: Wed, 18 Apr 2007 23:16:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070418211632.GA7610@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704181759.03559.mail@earthworm.de> <20070418164621.GA30744@elte.hu> <200704182245.24156.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704182245.24156.mail@earthworm.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Hesse <mail@earthworm.de> wrote:

> > i took a quick look at suspend2 and it makes some use of yield(). 
> > There's a bug in CFS's yield code, i've attached a patch that should 
> > fix it, does it make any difference to the hang?
> 
> This patch should apply cleanly against what? The second hunk is 
> ignored as it has already been applied. Is this correct?

hm, i think you might have had one of the earlier CFS patches.

> But no, it does not change anything. Let me know if you have any other 
> patches to test.

could you try the -v3 patch i released a few hours ago:

   http://redhat.com/~mingo/cfs-scheduler/

although probably your suspend2 problem is still not fixed, it's worth a 
try nevertheless. Which suspend2 patch did you apply, and was it against 
-rc6 or -rc7?

	Ingo
