Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYHHUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYHHUiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHHUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:38:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:49388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYHHUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:38:11 -0400
Subject: Re: [PATCH] printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, davem@davemloft.net, rostedt@goodmis.org
In-Reply-To: <20080808203241.GH6760@linux.vnet.ibm.com>
References: <1218202249.8625.106.camel@twins>
	 <alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	 <1218215454.8625.133.camel@twins>
	 <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	 <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	 <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	 <20080808121428.646a8b3c.akpm@linux-foundation.org>
	 <1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
	 <20080808123747.0db1c5dd.akpm@linux-foundation.org>
	 <20080808203241.GH6760@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 22:37:39 +0200
Message-Id: <1218227859.29098.24.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 13:32 -0700, Paul E. McKenney wrote:

> How about if I instead add comments warning people not to put printk()
> in the relevant RCU-implementation code?  That way I can be not only lazy,
> but cowardly as well!  ;-)

Well, it does spoil the party a little, we are now trading one deadlock
for another :-/



