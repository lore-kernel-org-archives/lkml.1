Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbYAHVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbYAHVxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYAHVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:53:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbYAHVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:53:07 -0500
Date: Tue, 8 Jan 2008 22:52:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rik van Riel <riel@redhat.com>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in
	arch/x86/ia32/ia32_aout.c
Message-ID: <20080108215247.GE14829@elte.hu>
References: <20080108203233.01bb5c7f@paolo-desktop> <20080108150439.6388028e@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108150439.6388028e@bree.surriel.com>
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


* Rik van Riel <riel@redhat.com> wrote:

> On Tue, 8 Jan 2008 20:32:33 +0100
> Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> 
> > Fix plenty of coding style errors
> 
> Most of these kernel changes would probably get in the way of real 
> development, making patches reject that would otherwise apply.

I'm curious, in what way would they interfere?

Firstly, anyone with a forked kernel with outstanding patches that are 
not in x86.git only has themselves to blame. We want to actively 
discourage forking and sitting on patches too long.

Secondly, when there _is_ some non-trivial interaction with reasonably 
recently-developed patches, the solution is simple and straightforward 
we simply undo the relevant portions of the cleanup, apply the 
functional patch and later on apply the (still relevant) cleanup patches 
to around the functional patch.

Since all new x86.git patches are checkpatch.pl clean, the modified 
portions need no cleanups anymore - only unmodified portions.

How many times did we have to do this in x86.git? Once or twice - out of 
100+ cleanup patches.

In reality, rarely do cleanup patches interfere. They have two positive 
effects besides the obvious readability, debuggability and 
maintainability advantages:

- they _do_ cause people to come out of their distro-patched
  fork-woodwork and submit their "development" patches (which were "in
  the works" for ... years).

- the cleanups make future development _easier_, because it's easier to
  develop on a clean codebase.

and because the number of future patches is infinitely larger than the 
number of still pending but not submitted development patches, we 
strongly favor cleanups.

so in the end it all works out fine.

	Ingo
