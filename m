Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYILLIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYILLIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYILLIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:08:39 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:35405 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477AbYILLIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:08:38 -0400
Date: Fri, 12 Sep 2008 16:37:37 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] sched: Fix __load_balance_iterator() for cfq with only
	one task
Message-ID: <20080912110737.GD20599@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080905123004.GD6238@in.ibm.com> <1220627628.11202.16.camel@twins.programming.kicks-ass.net> <1220635424.11202.20.camel@twins.programming.kicks-ass.net> <20080912063539.GB4872@in.ibm.com> <1221217028.9678.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221217028.9678.6.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 12:57:08PM +0200, Mike Galbraith wrote:
> On Fri, 2008-09-12 at 12:05 +0530, Gautham R Shenoy wrote:
> > On Fri, Sep 05, 2008 at 07:23:44PM +0200, Peter Zijlstra wrote:
> 
> > > ego, can you run sysbench to confirm?
> > 
> > Am planning to run it today.
> 
> I just tested rc6 with 6d299f1b53b84e2665f402d9bcc494800aba6386 applied,
> and it does not exhibit the problem which triggered the revert, so I'd
> suggest reverting it.  (Perhaps more clock manifestations)

That's good news!

Thanks for doing this
> 
> 	-Mike
> 

-- 
Thanks and Regards
gautham
