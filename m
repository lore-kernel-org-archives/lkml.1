Return-Path: <linux-kernel-owner+w=401wt.eu-S964974AbXCALiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbXCALiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964964AbXCALiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:38:10 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45523 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013AbXCALiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:38:09 -0500
Date: Thu, 1 Mar 2007 14:36:27 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301113627.GA19141@2ka.mipt.ru>
References: <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru> <20070301112700.GA897@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301112700.GA897@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 14:36:47 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:27:00PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > I've uploaded them to:
> > 
> > http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c
> > http://tservice.net.ru/~s0mbre/archive/kevent/evserver_kevent.c
> 
> thanks.
> 
> > I also changed client socket to nonblocking mode with the same result 
> > in epoll server. [...]
> 
> what does this mean exactly? Did you change this line in 
> evserver_epoll.c:
> 
>         //fcntl(cs, F_SETFL, O_NONBLOCK);
> 
> to:
> 
>         fcntl(cs, F_SETFL, O_NONBLOCK);
> 
> and the result was the same?

Yep.

> 	Ingo

-- 
	Evgeniy Polyakov
