Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbXFVHMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbXFVHMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXFVHL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:11:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40353 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbXFVHL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:11:58 -0400
Date: Fri, 22 Jun 2007 08:11:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 2/6] Split out tasklets from softirq.c
Message-ID: <20070622071151.GC21291@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	"David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
	kuznet@ms2.inr.ac.ru
References: <20070622040014.234651401@goodmis.org> <20070622040136.783692883@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622040136.783692883@goodmis.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 12:00:16AM -0400, Steven Rostedt wrote:
> Tasklets are really a separate entity from softirqs, so they
> deserve their own file. Also this allows us to easily replace
> tasklets for something else ;-)

It's a bit pointless when softirq.h still always includes it.  A while
ago I had a patch that split it out and made all users include it directly.
But reviving this patch would be rather pointless if we just want to kill
tasklets in the end anyway.

