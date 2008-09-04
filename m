Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYIDLfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYIDLfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbYIDLfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:35:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757719AbYIDLfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:35:43 -0400
Date: Thu, 4 Sep 2008 13:35:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
Message-ID: <20080904113529.GA25533@elte.hu>
References: <1220518266.9590.22.camel@minggr> <1220519034.8609.206.camel@twins> <1220525579.12161.8.camel@minggr> <20080904110901.GD8668@elte.hu> <1220527806.12161.14.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220527806.12161.14.camel@minggr>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> A huge trace result file, see the attachment for more.

> # tracer: sched_switch
> #
> #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> #              | |      |          |         |
>           mysqld-3799  [07]   151.411009:   3799:120:R ==>  3807:120:R
...
>         sysbench-3803  [07]   151.417048:   3803:120:R   +  3791:120:S

ok, this only spans 6 milliseconds, which is probably a bit too light.

Could you please increase the trace size 32-fold (via 
/debug/tracing/trace_entries), and send us the (large!) trace file 
compressed via bzip2 -9, off-list (or via a web link)? [anyone on-list 
can have a look at the smaller trace file already]

Thanks,

	Ingo
