Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbXKSXF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbXKSXF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXKSXFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:05:19 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:57694 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbXKSXFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:05:18 -0500
Date: Mon, 19 Nov 2007 15:05:16 -0800
From: Micah Dowty <micah@vmware.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071119230516.GC4736@vmware.com>
References: <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com> <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu> <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com> <20071116221404.GC31527@vmware.com> <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com> <20071117010352.GA13666@vmware.com> <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com> <20071119185116.GA28173@vmware.com> <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:22:06PM +0100, Dmitry Adamushko wrote:
> You seem to have a configuration with domains which don't have
> SD_BALANCE_NEWIDLE  on (CONFIG_NUMA?) as there are no events (all
> zeros above) for CPU_NEWLY_IDLE.
> 
> this one is being triggered whenever a cpu becomes idle (schedule()
> --> idle_balance() --> load_balance_newidle()).
> 
> (this flag is a bit #1 == 2)
> 
> cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags

Hmm. I don't have this file on my system:

root@micah-64:/proc/sys/kernel/sched_domain/cpu0/domain0# ls
busy_factor  busy_idx  forkexec_idx  idle_idx  imbalance_pct  max_interval  min_interval  newidle_idx  wake_idx
root@micah-64:/proc/sys/kernel/sched_domain/cpu0/domain0# uname -a
Linux micah-64 2.6.23.1 #1 SMP Fri Nov 2 12:25:47 PDT 2007 x86_64 GNU/Linux

Is there a config option I'm missing?

Thanks,
--Micah

