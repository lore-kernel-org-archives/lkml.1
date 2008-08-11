Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYHKOzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYHKOzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYHKOzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:55:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYHKOzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:55:44 -0400
Date: Mon, 11 Aug 2008 10:55:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Valdis.Kletnieks@vt.edu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
In-Reply-To: <20080811142900.GU9038@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0808111050160.29861@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
 <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <87zlnj24qc.fsf@basil.nowhere.org> <1218453726.10800.63.camel@twins> <20080811114243.GO9038@one.firstfloor.org> <22551.1218464121@turing-police.cc.vt.edu>
 <20080811142900.GU9038@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 11 Aug 2008, Andi Kleen wrote:

> $INSERT-ANY-OTHER-PRINTK-USE$
> 
> The point was that printk may have been perfectly adequate for 
> them with its existing buffer sizes and dynamic wake up frequency,
> and might not anymore with the timer wakeup change. Essentially
> it is making a widely used kernel facility more fragile.

I've measured several latencies in the kernel that would cause klogd to 
take serveral jiffies to wake up. I highly doubt that adding one jiffy 
will break anything. And if it did, then it would show a bug in their 
system. If adding one jiffy causes lost data, then the system 
administrators are relying on a utility (klogd) that can easily fail them 
without these patches.


If we are making a highly fragile setup a bit more fragile, maybe it will 
wake the IT guys up to change their setup.

-- Steve

