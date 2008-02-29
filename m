Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYB2RI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYB2RI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933493AbYB2RIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:08:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761181AbYB2RIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:08:34 -0500
Date: Fri, 29 Feb 2008 12:08:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       jarkao2@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] fix boot-time hangs from PREEMPT_RCU and NO_HZ
In-Reply-To: <20080229165752.GB7952@elte.hu>
Message-ID: <Pine.LNX.4.58.0802291207250.30943@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801291113350.20371@gandalf.stny.rr.com>
 <20080229044329.GA20207@linux.vnet.ibm.com> <20080228210140.37abe9cd.akpm@linux-foundation.org>
 <20080229154835.GB27248@elte.hu> <20080229165557.GC13330@linux.vnet.ibm.com>
 <20080229165752.GB7952@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Ingo Molnar wrote:
>
> no, sorry about me taking longer than usual about it - this is not a
> small patch and it had to be observed a bit longer. But as it is usual
> with your patches, it's working perfectly :-)

Not to mention that this patch has been in the -rt tree for some time now.
But you are right, it's a pretty big patch to go in without shaking it out
further.

Good to know that I hasn't needed any tweaks in the bigger arena.

-- Steve

