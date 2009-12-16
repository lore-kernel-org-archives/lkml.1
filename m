Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbZLPPa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbZLPPa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762227AbZLPPaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:30:25 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58749 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbZLPPaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:30:24 -0500
Date: Wed, 16 Dec 2009 07:30:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       tglx@linutronix.de
Subject: Re: [tip:sched/urgent] sched: Teach might_sleep() about
	preemptible RCU
Message-ID: <20091216153020.GD6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1260830672-7166-1-git-send-regression-fweisbec@gmail.com> <tip-ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd@git.kernel.org> <20091216142536.GA18091@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216142536.GA18091@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 03:25:36PM +0100, Ingo Molnar wrote:
> 
> * tip-bot for Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Commit-ID:  ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd
> > Gitweb:     http://git.kernel.org/tip/ba1b1cbcc9b458c4b9ebb28c9cf6a2ccf64ba1cd
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Mon, 14 Dec 2009 23:44:32 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 16 Dec 2009 08:43:16 +0100
> > 
> > sched: Teach might_sleep() about preemptible RCU
> 
> Causes a build failure, so skipped this patch for now:
> 
> kernel/sched.c:9661: error: implicit declaration of function 'rcu_preempt_depth'

I guess my testing missed something.  :-/  Could you please send the
.config file that caused this?

							Thanx, Paul
