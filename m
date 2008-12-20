Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYLTHz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYLTHz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 02:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYLTHzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 02:55:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYLTHzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 02:55:17 -0500
Date: Sat, 20 Dec 2008 08:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
       a.p.zijlstra@chello.nl, dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-ID: <20081220075418.GA2435@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175622.29812.69201.stgit@drishya.in.ibm.com> <20081219135508.9c6217ba.akpm@linux-foundation.org> <20081220043638.GA24181@dirshya.in.ibm.com> <20081219204455.5f954823.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219204455.5f954823.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 20 Dec 2008 10:06:38 +0530 Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > > 
> > > kernel/sched.c: In function 'schedule':
> > > kernel/sched.c:3679: warning: 'active_balance' may be used uninitialized in this function
> > > 
> > > This warning is correct - the code is buggy.
> > 
> > Yes this is my code bug.  I did not see the warning in sched.c.  Is
> > there any build option that I need to pass in order to get -Wall
> > effect?
> 
> That was just with plain old kbuild: `make allmodconfig;make'.
> 
> That warning was produced by gcc-4.0.2.  If you're using something more 
> recent then gcc has regressed.

hm, it didnt trigger here with gcc 4.3 - and the condition is serious. 
I've applied the fix, thanks guys!

	Ingo
