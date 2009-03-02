Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZCBOnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZCBOnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZCBOnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:43:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48288 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZCBOnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:43:22 -0500
Date: Mon, 2 Mar 2009 15:43:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Message-ID: <20090302144303.GA30136@elte.hu>
References: <1235996477.5330.174.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235996477.5330.174.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Hi Linus,
> 
> Would you be willing to take such a patch?
> 
> Its a rather big one, but if you think its a good idea, I can 
> generate one against whatever tree is needed.
> 
> Provided I didn't break any !genirq stuff.. then again, that 
> might be a nice incentive to fix up those last few archs.

look good IMO. If there are no objections, and given that it 
modifies half a thousand of files i'd suggest we do this near 
the end of the merge window and not carry it in the genirq tree 
- while trivial it will still generate quite a bit of conflicts. 
Would that work with you?

	Ingo
