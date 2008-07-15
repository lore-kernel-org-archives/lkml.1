Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbYGOSdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbYGOSdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYGOSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:33:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbYGOSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:33:29 -0400
Date: Tue, 15 Jul 2008 14:33:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 01/15] Kernel Tracepoints
In-Reply-To: <20080715182210.GA4334@Krystal>
Message-ID: <Pine.LNX.4.58.0807151431150.15149@gandalf.stny.rr.com>
References: <20080709145929.352201601@polymtl.ca> <20080709150043.693920317@polymtl.ca>
 <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal>
 <1216130593.12595.189.camel@twins> <20080715144628.GD20037@Krystal>
 <1216134829.12595.207.camel@twins> <20080715182210.GA4334@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
>
> I'm also wondering if it's better to have :
>
> filemap.h
> fs.h
> hugetlb.h
> ipc.h
> ipv4.h
> ipv6.h
> irq.h
> kernel.h
> memory.h
> net.h
> page.h
> sched.h
> swap.h
> timer.h

This might be a better idea.

>
> all in include/trace/ or to create subdirectories first, like :
>
> include/trace/net/
> include/trace/mm/

I think that is too much. A single trace directory should be sufficent.

> ....
>
> or to go the other way around and re-use the existing subdirectories :
>
> include/net/trace/
> include/mm/trace/
> ....

I'm definitely against that.

-- Steve

