Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbXFVSca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbXFVSca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759063AbXFVScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:32:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59103 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbXFVScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:32:20 -0400
Date: Fri, 22 Jun 2007 19:32:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622183217.GA18265@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	"David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
	kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 10:16:47AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 22 Jun 2007, Steven Rostedt wrote:
> > 
> > I just want to state that tasklets served their time well. But it's time
> > to give them an honorable discharge.  So lets get rid of tasklets and
> > given them a standing salute as they leave :-)
> 
> Well, independently of whether we actually discharge them or not, I do 
> tend to always like things that split independent concepts up (whether 
> they then end up being _implemented_ independently of each other or not is 
> a separate issue).
> 
> So patches 1-4 all look fine to me. In fact, 5 looks ok too.

I don't think we should put 3 and 4 in.  The code in drm is just crap and
should just be rewritten.  I'll cook up a patch, but I can't actually
yest it due to lack of hardware.

