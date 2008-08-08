Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbYHHSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbYHHSbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758985AbYHHSbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:31:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758891AbYHHSbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:31:39 -0400
Date: Fri, 8 Aug 2008 11:30:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] printk: robustify printk
In-Reply-To: <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.LFD.1.10.0808081127550.3462@nehalem.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>  <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>  <1206382547.6437.131.camel@lappy>  <20080324115738.85c72bb5.akpm@linux-foundation.org>  <1218202249.8625.106.camel@twins> 
 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>  <1218215454.8625.133.camel@twins>  <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>  <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> 
 <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Peter Zijlstra wrote:
>
> Avoid deadlocks against rq->lock and xtime_lock by using RCU to defer
> the klogd wakeup.

Ok, I can't see anything wrong with this from the patch. I do hate that 
deadlock, so I think I'll apply it. But I'll try to hold off for a while 
in case somebody has any last-minute comments..

		Linus
