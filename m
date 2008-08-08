Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbYHHUub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbYHHUub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYHHUuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:50:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58562 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYHHUuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:50:22 -0400
Date: Fri, 8 Aug 2008 16:50:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] printk: robustify printk
In-Reply-To: <1218227859.29098.24.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0808081649440.9641@gandalf.stny.rr.com>
References: <1218202249.8625.106.camel@twins>  <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>  <1218215454.8625.133.camel@twins>  <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>  <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
  <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>  <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>  <20080808121428.646a8b3c.akpm@linux-foundation.org>  <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> 
 <20080808123747.0db1c5dd.akpm@linux-foundation.org>  <20080808203241.GH6760@linux.vnet.ibm.com> <1218227859.29098.24.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Peter Zijlstra wrote:

> On Fri, 2008-08-08 at 13:32 -0700, Paul E. McKenney wrote:
> 
> > How about if I instead add comments warning people not to put printk()
> > in the relevant RCU-implementation code?  That way I can be not only lazy,
> > but cowardly as well!  ;-)
> 
> Well, it does spoil the party a little, we are now trading one deadlock
> for another :-/

Yeah, but only Paul and his clones would need printks in preempt RCU.

The rest of us mortals now have the rest of the kernel to play with.

-- Steve

