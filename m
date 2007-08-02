Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbXHBHUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbXHBHUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXHBHUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:20:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbXHBHUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:20:00 -0400
Date: Thu, 2 Aug 2007 09:19:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070802071956.GA23300@elte.hu>
References: <20070802021525.GC15595@wotan.suse.de> <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org> <20070802024132.GD15595@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802024132.GD15595@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > One thing to check out is whether the lmbench numbers are "correct". 
> > Especially on SMP systems, the lmbench numbers are actually *best* 
> > when the two processes run on the same CPU, even though that's not 
> > really at all the best scheduling - it's just that it artificially 
> > improves lmbench numbers because of the close cache affinity for the 
> > pipe data structures.
> 
> Yes, I bound them to a single core.

could you send me the .config you used?

	Ingo
