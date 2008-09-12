Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYILK5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYILK5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYILK5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:57:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:39058 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752477AbYILK5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:57:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX194/HoS5LZ41EBYV4huVb6lI7TR+0fKuxBmMLTXq8
	aHOlSm3uolej6u
Subject: Re: [PATCH] sched: Fix __load_balance_iterator() for cfq with only
	one task
From: Mike Galbraith <efault@gmx.de>
To: ego@in.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20080912063539.GB4872@in.ibm.com>
References: <20080905123004.GD6238@in.ibm.com>
	 <1220627628.11202.16.camel@twins.programming.kicks-ass.net>
	 <1220635424.11202.20.camel@twins.programming.kicks-ass.net>
	 <20080912063539.GB4872@in.ibm.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 12:57:08 +0200
Message-Id: <1221217028.9678.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-12 at 12:05 +0530, Gautham R Shenoy wrote:
> On Fri, Sep 05, 2008 at 07:23:44PM +0200, Peter Zijlstra wrote:

> > ego, can you run sysbench to confirm?
> 
> Am planning to run it today.

I just tested rc6 with 6d299f1b53b84e2665f402d9bcc494800aba6386 applied,
and it does not exhibit the problem which triggered the revert, so I'd
suggest reverting it.  (Perhaps more clock manifestations)

	-Mike

