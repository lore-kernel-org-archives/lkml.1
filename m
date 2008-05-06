Return-Path: <linux-kernel-owner+w=401wt.eu-S1764042AbYEFAYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764042AbYEFAYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYEFAY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:24:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239AbYEFAYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:24:25 -0400
Date: Tue, 6 May 2008 02:24:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080506002410.GC22499@elte.hu>
References: <20080505225823.GA24204@elte.hu> <20080505.171449.38412201.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505.171449.38412201.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 6 May 2008 00:58:23 +0200
> 
> > 
> > Linus, please pull the latest scheduler fixes git tree from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git for-linus
> > 
> > this tree got booted up ~10 times on x86. Thanks,
> 
> Sanity booted and moderately tested on 64-cpu and 128-cpu Niagara2 
> systems.

thanks David!

btw., this has the CONFIG_HAVE_UNSTABLE_SCHED_CLOCK changes from Peter 
which should improve things on Niagara2. Note that cpu_clock() still has 
sync overhead - this will simply go away, once we are reasonably sure 
about the current sched_clock() code on x86. Those bits still need more 
testing.

	Ingo
