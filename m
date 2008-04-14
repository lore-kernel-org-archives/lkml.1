Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYDNPlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYDNPlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYDNPls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:41:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbYDNPls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:41:48 -0400
Date: Mon, 14 Apr 2008 17:41:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080414154129.GB22259@elte.hu>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080413070513.GB19773@elte.hu> <20080413125205.GP11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413125205.GP11962@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Sun, Apr 13, 2008 at 09:05:13AM +0200, Ingo Molnar wrote:
> > there's also another aspect: completions are faster a bit 
> > in theory, because they know that they will schedule most of the time - 
> > while semaphores assume that they will _not_ schedule. (And that's 
> > exactly because the intent of the developer when using a completion is 
> > crystal clear.)
> 
> In practice though, the current implementation is slower. [...]

any URL to benchmarks?

> [...] Of course, that's fixable, and I strongly suspect that the 
> current users of completions simply don't care about speed -- the 
> normal use of completions is in startup and shutdown paths where a 
> millisecond extra isn't going to be noticable.

completions and semaphores act in the sub-microsecond range, not in the 
milliseconds range.

	Ingo
