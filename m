Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYIFQCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYIFQCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYIFQCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:02:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYIFQCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:02:10 -0400
Date: Sat, 6 Sep 2008 18:01:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5] BUILD_BUG_ON: error on none-const expressions
Message-ID: <20080906160137.GC5061@elte.hu>
References: <48BBE77D.7070007@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BBE77D.7070007@panasas.com>
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


* Boaz Harrosh <bharrosh@panasas.com> wrote:

> Submitted a patchset to fix BUILD_BUG_ON to no longer let through
> none compile-time constant expressions. This was debated a few
> times on LKML. The final solution is as proposed by Rusty Russell,
> which produces all expected results in my tests.
> [see: http://www.spinics.net/lists/kernel/msg772904.html]
> 
> [PATCH 1/5] debug, x86: move BUILD_BUG_ON() ARRAY_SIZE and __FUNCTION__
>   Ingo this is your patch. Please verify?

yeah.

Acked-by: Ingo Molnar <mingo@elte.hu>

> [PATCH 5/5] debug: BUILD_BUG_ON: error on none-const expressions
>   Finally after all call sites are fixed this can go in.
>   (Rusty this one is From: you)

v3 looks good to me.

Andrew, are you picking this up? Looks like the perfect fit for -mm to 
me. I can drop the previous version from -tip so that there's no 
linux-next conflict.

	Ingo
