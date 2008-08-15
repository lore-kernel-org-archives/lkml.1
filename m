Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYHOONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYHOONS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYHOONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:13:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYHOOND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:13:03 -0400
Date: Fri, 15 Aug 2008 16:09:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@tv-sign.ru,
       manfred@colorfullife.com, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier
	cleanups
Message-ID: <20080815140902.GE14103@elte.hu>
References: <20080805162144.GA8297@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805162144.GA8297@linux.vnet.ibm.com>
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

> This patch simplifies the locking and memory-barrier usage in the 
> Classic RCU grace-period-detection mechanism, incorporating Lai 
> Jiangshan's feedback from the earlier version 
> (http://lkml.org/lkml/2008/8/1/400 and 
> http://lkml.org/lkml/2008/8/3/43).  Passed 10 hours of rcutorture 
> concurrent with CPUs being put online and taken offline on a 
> 128-hardware-thread Power machine.  My apologies to whoever in the 
> Eastern Hemisphere was planning to use this machine over the Western 
> Hemisphere night, but it was sitting idle and...
> 
> So this is ready for tip/core/rcu.

applied to tip/core/rcu - thanks Paul!

	Ingo
