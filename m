Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXFXPw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXFXPw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbXFXPwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:52:21 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:37342 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbXFXPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:52:21 -0400
Date: Sun, 24 Jun 2007 11:52:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jonathan Corbet <corbet@lwn.net>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues 
In-Reply-To: <10876.1182698167@lwn.net>
Message-ID: <Pine.LNX.4.58.0706241149380.6072@gandalf.stny.rr.com>
References: <10876.1182698167@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 24 Jun 2007, Jonathan Corbet wrote:
>
> The cafe_ccic (OLPC) camera driver uses a tasklet to move frames out of
> the DMA buffers in the streaming I/O path.  With this change in place,
> I'd worry that the possibility of dropping frames would increase,
> especially considering that (1) this is running on OLPC hardware, and
> (2) there is typically a streaming video application running in user
> space.
>
> Obviously some testing is called for here.  I will make an attempt to do
> that testing, but the next few weeks involve some insane travel which
> will make that hard.  Stay tuned.
>

Jon,

Thanks for pointing this driver out. I'd greatly appreciate any report
you give us regarding the effect of having the tasklet as a thread.

-- Steve

