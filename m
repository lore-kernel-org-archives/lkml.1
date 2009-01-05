Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZAENG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZAENG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZAENGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:06:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZAENGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:06:46 -0500
Date: Mon, 5 Jan 2009 14:06:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090105130638.GB6014@elte.hu>
References: <20090104174450.GB4301@dirshya.in.ibm.com> <1231092523.29980.4.camel@twins> <20090105040635.GF4301@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105040635.GF4301@dirshya.in.ibm.com>
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-04 19:08:43]:
> 
> > On Sun, 2009-01-04 at 23:14 +0530, Vaidyanathan Srinivasan wrote:
> > > Hi Ingo,
> > > 
> > > Kernbench runs on latest Linux git tree stalled with the following
> > > lockdep warning.
> > > 
> > > Lockdep warning and lockup on Jan 3 Linus git tree
> > > commit 7d3b56ba37a95f1f370f50258ed3954c304c524b
> > > 
> > > kernbench run with two threads stalled.  sched_mc was zero.
> > > x86_64 system with 8 logical CPUs in dual socket quad core
> > > configuration.
> > > 
> > > I will post more information as I debug this warning/bug.  
> > 
> > Its ca109491f612aab5c8152207631c0444f63da97f, I've some ideas on how to
> > fix this, just haven't gotten around to actually doing anything --
> > seeing how it was holidays and such..
> 
> Hi Peter,
> 
> I can definitely test your fix when you have them.  I have an
> autotest job that hits this bug.

could you check latest tip/master, it has Peter's and Thomas's hrtimer 
fixes.

	Ingo
