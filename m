Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbXBZKff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbXBZKff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXBZKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:35:35 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34625 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXBZKfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:35:33 -0500
Date: Mon, 26 Feb 2007 13:33:19 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226103319.GA24284@2ka.mipt.ru>
References: <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru> <20070226095547.GA9485@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226095547.GA9485@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 13:34:37 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 10:55:47AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > I will use Ingo's evserver_threadlet server as plong as evserver_epoll 
> > (with fixed closing) and evserver_kevent.c.
> 
> please also try evserver_epoll_threadlet.c that i've attached below - it 
> uses epoll as the main event mechanism but does threadlets for request 
> handling.
> 
> This is a one step more intelligent threadlet queueing model than 
> 'thousands of threads' - although obviously epoll alone should do well 
> too with this trivial workload.

No problem.
If I will complete setup today before I go climbing (I need to do some 
paid job too), I will post results here and in my blog (without
political correctness).

Btw, 'evserver' in the name means 'event server', so you might think
about changing the name :)

Stay tuned.

> 	Ingo

-- 
	Evgeniy Polyakov
