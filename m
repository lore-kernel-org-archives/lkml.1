Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbXKTF63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbXKTF63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXKTF6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:58:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51657 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXKTF6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:58:20 -0500
Date: Tue, 20 Nov 2007 06:57:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Micah Dowty <micah@vmware.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071120055755.GE20436@elte.hu>
References: <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu> <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com> <20071116221404.GC31527@vmware.com> <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com> <20071117010352.GA13666@vmware.com> <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com> <20071119185116.GA28173@vmware.com> <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com> <20071119230516.GC4736@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119230516.GC4736@vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Micah Dowty <micah@vmware.com> wrote:

> > this one is being triggered whenever a cpu becomes idle (schedule() 
> > --> idle_balance() --> load_balance_newidle()).
> > 
> > (this flag is a bit #1 == 2)
> > 
> > cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags
> 
> Hmm. I don't have this file on my system:
> 
> root@micah-64:/proc/sys/kernel/sched_domain/cpu0/domain0# ls
> busy_factor  busy_idx  forkexec_idx  idle_idx  imbalance_pct  max_interval  min_interval  newidle_idx  wake_idx
> root@micah-64:/proc/sys/kernel/sched_domain/cpu0/domain0# uname -a
> Linux micah-64 2.6.23.1 #1 SMP Fri Nov 2 12:25:47 PDT 2007 x86_64 GNU/Linux
> 
> Is there a config option I'm missing?

yes, CONFIG_SCHED_DEBUG.

	Ingo
