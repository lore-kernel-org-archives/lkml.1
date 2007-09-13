Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbXIMLsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbXIMLsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXIMLse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:48:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbXIMLse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:48:34 -0400
Date: Thu, 13 Sep 2007 13:48:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913114828.GA28339@elte.hu>
References: <20070911200459.GA6974@elte.hu> <6b8cef970709111816l2e421bf3s55e63274e87fd5e1@mail.gmail.com> <6b8cef970709130142h7be591f7ja5ffd8976faef09c@mail.gmail.com> <20070913090655.GA28505@elte.hu> <6b8cef970709130224t2f8d28d4mdfbf22ba10b42497@mail.gmail.com> <20070913093137.GA31923@elte.hu> <6b8cef970709130236o48e4d923ofe4ad862c749f2da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8cef970709130236o48e4d923ofe4ad862c749f2da@mail.gmail.com>
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


* Rob Hussey <robjhussey@gmail.com> wrote:

> Well, I was going over my config myself after you asked for me to post
> it, and I thought to do the same thing. Except, disabling sched_debug
> caused the same error as before:
> In file included from kernel/sched.c:794:
> kernel/sched_fair.c: In function 'task_new_fair':
> kernel/sched_fair.c:857: error: 'sysctl_sched_child_runs_first'
> undeclared (first use in this function)
> kernel/sched_fair.c:857: error: (Each undeclared identifier is
> reported only once
> kernel/sched_fair.c:857: error: for each function it appears in.)
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 
> It only happens with sched_debug=y. I take it back, it wasn't my fault :)
> 
> As for everything else, I'd be happy to.

are you sure this is happening with the latest iteration of the patch 
too? (with the combo-3.patch?) You can pick it up from here:

   http://people.redhat.com/mingo/cfs-scheduler/devel/sched-cfs-v2.6.23-rc6-v21-combo-3.patch

I tried your config and it builds fine here.

	Ingo
