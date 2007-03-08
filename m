Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXCHIxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXCHIxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030305AbXCHIxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:53:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48007 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030302AbXCHIxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:53:43 -0500
Date: Thu, 8 Mar 2007 09:53:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Message-ID: <20070308085302.GA18245@elte.hu>
References: <200703041800.53360.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703041800.53360.kernel@kolivas.org>
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


* Con Kolivas <kernel@kolivas.org> wrote:

> This message is to announce the first general public release of the 
> "Rotating Staircase DeadLine" cpu scheduler.
> 
> Based on previous work from the staircase cpu scheduler I set out to 
> design, from scratch, a new scheduling policy design which satisfies 
> every requirement for SCHED_NORMAL (otherwise known as SCHED_OTHER) 
> task management.

cool! I like this even more than i liked your original staircase 
scheduler from 2 years ago :) Lets try what we did back then: put it 
into -mm and see what breaks (if anything). But in general, it is 
becoming increasingly clear that the interactivity estimator is a more 
fragile concept than the built-in quota mechanism of the staircase 
scheduler, so if it works in practice i'm quite in favor of it, even if 
it regresses /some/ workloads.

	Ingo
