Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbYF3NAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbYF3NAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYF3NAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:00:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbYF3NAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:00:16 -0400
Date: Mon, 30 Jun 2008 14:59:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/30] SMP-group balancer - take 3
Message-ID: <20080630125956.GD4011@elte.hu>
References: <20080627114109.724249622@chello.nl> <20080627173355.GA11381@linux.vnet.ibm.com> <20080628170828.GA2002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080628170828.GA2002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Hi,
> 
> I get this at bootup
> 
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2738 check_flags+0x8a/0x12d()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-rc8-tip #5

please check latest tip/master. This is the commit that should fix it:

----------------
| commit 2d452c9b10caeec455eb5e56a0ef4ed485178213
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Sun Jun 29 15:01:59 2008 +0200
|
|     sched: sched_clock_cpu() based cpu_clock(), lockdep fix
|
|     Vegard Nossum reported:
|
|     > WARNING: at kernel/lockdep.c:2738 check_flags+0x142/0x160()
----------------

	Ingo
