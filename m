Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZILOgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZILOgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 10:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZILOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 10:36:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57138 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZILOgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 10:36:20 -0400
Date: Sat, 12 Sep 2009 07:36:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH tip/core/rcu 1/3] rcutorture: Occasionally delay readers
	enough to make RCU force_quiescent_state
Message-ID: <20090912143621.GD6867@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090908225349.GA19524@linux.vnet.ibm.com> <20090912074540.GA25519@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912074540.GA25519@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 09:45:40AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > From: Josh Triplett <josh@joshtriplett.org>
> > 
> > rcutorture already delays readers, but never for long enough to make RCU
> > force a quiescent state.  Add an occasional delay of 50ms.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
> Small patch flow nit - your Signed-off-by after Josh's signoff is 
> missing.

/me rechecks the "git am" manpage, sees "-s".

Apologies for my confusion, thank you for fixing it!

							Thanx, Paul
