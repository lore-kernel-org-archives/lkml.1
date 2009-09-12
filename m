Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZILHqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZILHqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZILHqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:46:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZILHqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:46:07 -0400
Date: Sat, 12 Sep 2009 09:45:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH tip/core/rcu 1/3] rcutorture: Occasionally delay
	readers enough to make RCU force_quiescent_state
Message-ID: <20090912074540.GA25519@elte.hu>
References: <20090908225349.GA19524@linux.vnet.ibm.com> <12524504772607-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12524504772607-git-send-email->
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> From: Josh Triplett <josh@joshtriplett.org>
> 
> rcutorture already delays readers, but never for long enough to make RCU
> force a quiescent state.  Add an occasional delay of 50ms.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Small patch flow nit - your Signed-off-by after Josh's signoff is 
missing.

	Ingo
