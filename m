Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbXIXV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbXIXV7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXIXV7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:59:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbXIXV7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:59:11 -0400
Date: Mon, 24 Sep 2007 23:59:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070924215900.GA23913@elte.hu>
References: <20070924214537.GA18980@elte.hu> <20070924145530.5b09acd9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924145530.5b09acd9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 24 Sep 2007 23:45:37 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > The latest sched-devel.git tree can be pulled from:
> >  
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> 
> I'm pulling linux-2.6-sched.git, and it's oopsing all over the place 
> on ia64, and Lee's observations about set_leftmost()'s weirdness are 
> pertinent.
> 
> Should I instead be pulling linux-2.6-sched-devel.git?

yeah, please pull that one.

linux-2.6-sched.git by mistake contained an older sched-devel tree for 
about a day (where your scripts picked it up). I've restored that one to 
-rc7 meanwhile. It's only supposed to contain strict fixes for upstream. 
(none at the moment)

	Ingo
