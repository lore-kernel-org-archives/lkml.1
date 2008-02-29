Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbYB2TqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbYB2TqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758705AbYB2TqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:46:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbYB2TqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:46:01 -0500
Date: Fri, 29 Feb 2008 20:45:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Message-ID: <20080229194547.GC21249@elte.hu>
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com> <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu> <f19298770802281324v1fc37cf4oebd680b81d0e0a2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770802281324v1fc37cf4oebd680b81d0e0a2f@mail.gmail.com>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> On Thu, Feb 28, 2008 at 11:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  > > Anything else I can do?
> >  >
> >  > yes, please test the patch below - does it fix the problem?
> 
> The patch worked well, thanks
> 
> I still observe some uneven mouse behaviour during compilations (linux 
> kernel, make -j 6), like, when I slowly move the mouse, it would stop 
> for a split of a second every few seconds (the intervals are not 
> equal). On 2.6.23/24 it works very smooth. Of course, I can't say that 
> the scheduler is to be blamed. It was only my assumption because I 
> thought I might be confused by the non-monotinic time, which I see is 
> not the case. Any ideas, how to debug this?

could you try latencytop, what does it say, what type of scheduler (and 
other) delays are there?

	Ingo
