Return-Path: <linux-kernel-owner+w=401wt.eu-S932782AbXCBINj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbXCBINj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbXCBINj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:13:39 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36178 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782AbXCBINi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:13:38 -0500
Date: Fri, 2 Mar 2007 11:10:48 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070302081047.GA27122@2ka.mipt.ru>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 02 Mar 2007 11:11:26 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 11:31:14AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Thu, 1 Mar 2007, Evgeniy Polyakov wrote:
> 
> > Ingo, do you really think I will send mails with faked benchmarks? :))
> 
> I don't think he ever implied that. He was only suggesting that when you 
> post benchmarks, and even more when you make claims based on benchmarks, 
> you need to be extra carefull about what you measure. Otherwise the 
> external view that you give to others does not look good.
> Kevent can be really faster than epoll, but if you post broken benchmarks 
> (that can be, unrealiable HTTP loaders, broken server implemenations, 
> etc..) and make claims based on that, the only effect that you have is to 
> lose your point.
 
We seems to move far away from original topic - I never built any
assumptions on top of kevent _performance_ - kevent is a logical
extrapolation of the epoll, I only showed that event driven model can be
fast and it outperforms threadlet one - after we changed topic we were
unable to actually test threadlets in networking environment, since the
only test I ran showed that threadlest do not reschedule at all, and
Ingo's tests showed small number of reschedulings.

So, I only talked that kevent is superior compared to epoll because (and
it is _main_ issue) of its ability to handle essentially any kind of
events with very small overhead (the same as epoll has in struct file -
list and spinlock) and without significant price of struct file binding
to event.

I did not want and do not want to hurt anyone (even Ingo, although he is 
against kevent :), but my opinion is that thread moved from nice 
discussion about threads and events with jokes and fun into quite angry 
word throwings, and that is too good - let's make it fun again.
I'm not a native english speaker (and do not use a dictionary), so it is 
quite possible that some my phrases were not exactly nice, but it was 
unintentional (at least not very) :)

Peace?

> - Davide
> 

-- 
	Evgeniy Polyakov
