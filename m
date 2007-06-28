Return-Path: <linux-kernel-owner+w=401wt.eu-S1765797AbXF1Uqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797AbXF1Uqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759655AbXF1Uqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:46:38 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:42803 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXF1Uqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:46:37 -0400
Date: Thu, 28 Jun 2007 16:46:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dan Williams <dan.j.williams@intel.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <e9c3a7c20706281102l5db2e91alf465e7983d68f284@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0706281632510.27157@gandalf.stny.rr.com>
References: <20070622040014.234651401@goodmis.org> 
 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> 
 <20070622204058.GA11777@elte.hu>  <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
  <20070622215953.GA22917@elte.hu>  <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
  <1182823276.5493.240.camel@localhost.localdomain> 
 <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com> 
 <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
 <e9c3a7c20706281102l5db2e91alf465e7983d68f284@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Dan Williams wrote:
> >
> Unfortunately setting the thread to real time priority makes
> throughput slightly worse.  Instead of floating around 35MB/s the
> resync speed is stuck around 30MB/s:

That is really strange. If you higher the prio of the work queue it
gets worst?  Something really strange is happening here?  Are you using
CONFIG_PREEMPT?

-- Steve

