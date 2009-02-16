Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZBPUJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZBPUJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZBPUJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:09:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZBPUJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:09:39 -0500
Date: Mon, 16 Feb 2009 21:09:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216200923.GA28938@elte.hu>
References: <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu> <20090216084223.GA2641@localhost.localdomain> <20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr> <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216185616.GB6785@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Here the calls to rcu_process_callbacks() are only 75 
> microseconds apart, so that this function is consuming more 
> than 10% of a CPU.  The strange thing is that I don't see a 
> raise_softirq() in between, though perhaps it gets inlined or 
> something that makes it invisible to ftrace.

look at the latest trace please, that has even the most inline 
raise-softirq method instrumented, so all the raising is 
visible.

	Ingo
