Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbXF1S1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbXF1S1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763526AbXF1S1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:27:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765424AbXF1S1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:27:39 -0400
Date: Thu, 28 Jun 2007 11:19:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-Id: <20070628111959.f7413d0e.akpm@linux-foundation.org>
In-Reply-To: <20070628160001.GA15495@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	<alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	<20070622204058.GA11777@elte.hu>
	<alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	<20070622215953.GA22917@elte.hu>
	<46834BB8.1020007@garzik.org>
	<20070628092340.GB23566@elte.hu>
	<20070628143850.GA11780@ms2.inr.ac.ru>
	<20070628160001.GA15495@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 18:00:01 +0200 Ingo Molnar <mingo@elte.hu> wrote:

>  with 1.2 usecs and 10,000 
> irqs/sec the cost is 1.2 msecs/sec, or 0.1%.

off-by-10 error.
