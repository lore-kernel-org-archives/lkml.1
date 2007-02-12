Return-Path: <linux-kernel-owner+w=401wt.eu-S964853AbXBLKjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbXBLKjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964856AbXBLKjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:39:21 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43336 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964853AbXBLKjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:39:19 -0500
Date: Mon, 12 Feb 2007 13:35:10 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@osdl.org>
Cc: David Miller <davem@davemloft.net>, Ulrich Drepper <drepper@redhat.com>,
       netdev <netdev@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chase Venters <chase.venters@clientec.com>,
       Johann Borck <johann.borck@densedata.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Jamal Hadi Salim <hadi@cyberus.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org
Subject: Re: [take35 0/10] kevent: Generic event handling mechanism.
Message-ID: <20070212103510.GC5703@2ka.mipt.ru>
References: <asdasdqaa0591036@2ka.mipt.ru> <11703247503374@2ka.mipt.ru> <20070205142336.GA24190@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070205142336.GA24190@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Mon, 12 Feb 2007 13:35:54 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 05:23:36PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> On Thu, Feb 01, 2007 at 01:12:30PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> > 
> > Generic event handling mechanism.
> > 
> > Kevent is a generic subsytem which allows to handle event notifications.
> > It supports both level and edge triggered events. It is similar to
> > poll/epoll in some cases, but it is more scalable, it is faster and
> > allows to work with essentially eny kind of events.
> > 
> > Events are provided into kernel through control syscall and can be read
> > back through ring buffer or using usual syscalls.
> > Kevent update (i.e. readiness switching) happens directly from internals
> > of the appropriate state machine of the underlying subsytem (like
> > network, filesystem, timer or any other).
> > 
> > Homepage:
> > http://tservice.net.ru/~s0mbre/old/?section=projects&item=kevent
> > 
> > Documentation page:
> > http://linux-net.osdl.org/index.php/Kevent
> > 
> > Consider for inclusion.
> > 
> > P.S. If you want to be removed from Cc: list just drop me a mail.
> > 
> > Changes from 'take34' patchset:
> >  * Ported to the 2.6.20-rc7 (9be5b038b1c9d1927c367bf91683458e10d5d4eb) tree.
> 
> Is there some progress?
> Some things to be implemented, described or discussed?

I think that mean that everybody is happy with APi, design and set of
features. 

Andrew, do you consider kevent for inclusion or declining?

-- 
	Evgeniy Polyakov
