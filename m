Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZHXPhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZHXPhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZHXPhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:37:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52608 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZHXPg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:36:59 -0400
Date: Mon, 24 Aug 2009 08:36:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH -tip] v3 Renamings to increase RCU clarity.
Message-ID: <20090824153658.GD6677@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090727181401.GA14120@linux.vnet.ibm.com> <4A923EA5.2080903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A923EA5.2080903@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 03:17:57PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

[ . . . ]

> > +static inline void rcu_read_lock_sched_notrace(void)
> > +{
> > +	preempt_disable_notrace();
> > +}
> 
> It need be marked "notrace". Sometimes a function marked "inline"
> may not be inlined when it is compiled.
> 
> Lai.

Good eyes, and thank you -very- much!!!  I doubt that I would have ever
spotted this on my own, as I was just assuming that the compiler would
see the preempt_disable_notrace() directly in all cases...

							Thanx, Paul
