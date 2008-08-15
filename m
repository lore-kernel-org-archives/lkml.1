Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYHOPCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYHOPCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYHOPCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:02:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51956 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbYHOPCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:02:44 -0400
Date: Fri, 15 Aug 2008 17:02:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       akpm@linux-foundation.org, ego@in.ibm.com, dvhltc@us.ibm.com,
       niv@us.ibm.com
Subject: Re: [PATCH -tip/core/rcu] fixes to include/linux/rcupreempt.h
Message-ID: <20080815150226.GC10029@elte.hu>
References: <20080801211002.GM14851@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801211002.GM14851@linux.vnet.ibm.com>
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

> Hello!
> 
> Compared tip/core/rcu to my latest patchset, and found the following
> issues:
> 
> o	the memory barrier in rcu_exit_nohz() somehow got out of place
> 	(it is correct in mainline as of 2.6.26-rc7).
> 
> o	There is a duplicate declaration of rcu_dyntick_sched.
> 
> The attached patch fixes these.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

applied to tip/core/rcu - thanks Paul.

	Ingo
