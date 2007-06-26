Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbXFZAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbXFZAA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXFZAAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:00:14 -0400
Received: from vena.lwn.net ([206.168.112.25]:51598 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbXFZAAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:00:13 -0400
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru, Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sun, 24 Jun 2007 09:16:07 MDT."
             <10876.1182698167@lwn.net> 
Date: Mon, 25 Jun 2007 18:00:12 -0600
Message-ID: <10203.1182816012@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of days ago I said:

> The cafe_ccic (OLPC) camera driver uses a tasklet to move frames out of
> the DMA buffers in the streaming I/O path....
> 
> Obviously some testing is called for here.  I will make an attempt to do
> that testing

I've done that testing - I have an OLPC B3 unit running V2 of the
tasklet->workqueue patch, and all seems well.  30 FPS to the display and
no dropped frames.  The tasklets/0 process is running 3-5% CPU, in case
that's interesting.  For whatever reason, I see about 3% *more* idle
time when running just mplayer than I did without the patch.

Consider my minor qualms withdrawn, there doesn't seem to be any trouble
in this area.

Thanks,

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
