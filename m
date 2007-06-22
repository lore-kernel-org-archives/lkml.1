Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXFVHxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXFVHxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXFVHxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:53:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40276 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXFVHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:53:13 -0400
Date: Fri, 22 Jun 2007 08:53:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622075304.GA22682@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	"David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
	kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org> <20070622070948.GA21291@infradead.org> <20070622075135.GA11695@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622075135.GA11695@elte.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 09:51:35AM +0200, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > I think we probably want some numbers, at least for tasklets used in 
> > potentially performance critical code.
> 
> which actual in-kernel tasklets do you have in mind? I'm not aware of 
> any in performance critical code. (now that both the RCU and the sched 
> tasklet has been fixed.)

the one in megaraid_sas for example is in a performance-critical path
and was put in quite recently.
