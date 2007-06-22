Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbXFVMoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbXFVMoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXFVMoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:44:11 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:41845 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbXFVMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:44:09 -0400
Subject: Re: [RFC PATCH 2/6] Split out tasklets from softirq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622071151.GC21291@infradead.org>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040136.783692883@goodmis.org>
	 <20070622071151.GC21291@infradead.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 08:40:38 -0400
Message-Id: <1182516038.5493.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 08:11 +0100, Christoph Hellwig wrote:
> On Fri, Jun 22, 2007 at 12:00:16AM -0400, Steven Rostedt wrote:
> > Tasklets are really a separate entity from softirqs, so they
> > deserve their own file. Also this allows us to easily replace
> > tasklets for something else ;-)
> 
> It's a bit pointless when softirq.h still always includes it.  A while
> ago I had a patch that split it out and made all users include it directly.
> But reviving this patch would be rather pointless if we just want to kill
> tasklets in the end anyway.
> 

Actually, if these patches do make it into -mm, then patches 1-4 should
make it into Linus's tree. That will make Andrews maintenance of these
patches much easier, since they would make the -mm changes not so
intrusive.

Since the stripping out of tasklets is more of a cosmetic change and
does not change functionality of the kernel, I don't see why it can't
make it up to Linus's tree. Especially if we are planning on removing
tasklets all together.

-- Steve


