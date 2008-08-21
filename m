Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYHUBCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYHUBCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 21:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYHUBB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 21:01:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYHUBB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 21:01:59 -0400
Date: Wed, 20 Aug 2008 21:01:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       ego@in.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH -tip/core/rcu] fixes to include/linux/rcupreempt.h
In-Reply-To: <20080820223359.GL6758@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0808202101200.27236@gandalf.stny.rr.com>
References: <20080801211002.GM14851@linux.vnet.ibm.com> <alpine.DEB.1.10.0808201215330.27481@gandalf.stny.rr.com> <20080820223359.GL6758@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2008, Paul E. McKenney wrote:
> > > -DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
> > 
> > In -rt we deleted the first declaration. Is rcu_dyntick_sched defined on
> > !CONFIG_NO_HZ?
> 
> It builds for me in current tip/core/rcu without the above
> DECLARE_PER_CPU().  And the reason is the call_rcu_sched() function, which
> requires rcu_dyntick_sched.sched_qs and rcu_dyntick_sched.sched_qs_snap
> be defined even if !CONFIG_NO_HZ.
> 
> I suppose I could remove the other elements from the rcu_dyntick_sched
> structure if !CONFIG_NO_HZ.  Worthwhile?
> 

Nah, forget about it. I've got a few different versions I'm dealing with.

Thanks,

-- Steve

