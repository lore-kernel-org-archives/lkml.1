Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXFVMjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXFVMjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXFVMj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:39:27 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:37869 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbXFVMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:39:26 -0400
Subject: Re: [RFC PATCH 1/6] Convert the RCU tasklet into a softirq
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622074344.GA9472@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <20070622040136.621853953@goodmis.org>
	 <20070622071039.GB21291@infradead.org>  <20070622074344.GA9472@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 08:35:47 -0400
Message-Id: <1182515747.5493.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 09:43 +0200, Ingo Molnar wrote:
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Fri, Jun 22, 2007 at 12:00:15AM -0400, Steven Rostedt wrote:
> > > I believe this was originally done by Dipankar Sarma. I pulled these
> > > changes from the -rt kernel.
> > > 
> > > For better preformance, RCU should use a softirq instead of a
> > > tasklet.
> > 
> > I was under the imporession we had merged this a while ago due to 
> > tasklet bottlenecks on big machines.  Any reason why it has been 
> > delayed so long?
> 
> i thought so too, up until a few weeks ago. I think i might have mixed 
> it up mentally with the scheduler rebalancing tasklet: that was 
> converted to softirqs on my request and made me forget about the RCU 
> tasklet thing.
> 

I think the reason it was dropped was because it was part of a large
patch series that didn't make it into the kernel. And unfortunately,
this was dropped in that regard.


If you do pull this patch in, I would like to get a sign-off-by from
Dipankar and give him credit, since I think he was the original author.
I just pulled it out of the -rt branch.

-- Steve


