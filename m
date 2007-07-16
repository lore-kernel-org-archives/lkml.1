Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbXGPU0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbXGPU0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXGPU02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:26:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204AbXGPU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:26:27 -0400
Date: Mon, 16 Jul 2007 13:23:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 1/8] Convert the RCU tasklet into a softirq
In-Reply-To: <20070716201251.GB12458@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.0.999.0707161322440.20061@woody.linux-foundation.org>
References: <20070627193633.025544061@goodmis.org> <20070627194327.241131609@goodmis.org>
 <20070716201251.GB12458@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jul 2007, Paul E. McKenney wrote:
>
> On Wed, Jun 27, 2007 at 03:36:34PM -0400, Steven Rostedt wrote:
> > I believe this was originally done by Dipankar Sarma. I pulled these
> > changes from the -rt kernel.
> > 
> > For better preformance, RCU should use a softirq instead of a
> > tasklet.
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Tested with both kernbench and rcutorture on i386, x86_64, and ppc64.

Btw, are there any numbers on this? Is this whole thing actually 
noticeable?

		Linus
