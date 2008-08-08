Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYHHRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYHHRwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYHHRwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:52:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbYHHRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:52:13 -0400
Date: Fri, 8 Aug 2008 13:52:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
In-Reply-To: <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0808081351400.6116@gandalf.stny.rr.com>
References: <20080324122424.671168000@chello.nl>  <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>  <1206382547.6437.131.camel@lappy>  <20080324115738.85c72bb5.akpm@linux-foundation.org>  <1218202249.8625.106.camel@twins> 
 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>  <1218215454.8625.133.camel@twins>  <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Peter Zijlstra wrote:
> > 
> > For that last thing, maybe we can just make it a percpu thing and just 
> > disable irq's?
> 
> You're _so_ right! :-)
> 
> This is much prettier and boots to boot.
> 
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

If this makes any difference:

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve
