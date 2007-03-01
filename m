Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXCALu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXCALu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbXCALu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:50:58 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54078 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253AbXCALu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:50:57 -0500
Date: Thu, 1 Mar 2007 14:47:31 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070301114731.GA20773@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <200703011214.45144.dada1@cosmosbay.com> <20070301112017.GB27381@2ka.mipt.ru> <200703011228.01144.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200703011228.01144.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 14:48:50 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:28:00PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> On Thursday 01 March 2007 12:20, Evgeniy Polyakov wrote:
> > On Thu, Mar 01, 2007 at 12:14:44PM +0100, Eric Dumazet (dada1@cosmosbay.com) 
> wrote:
> > > On Thursday 01 March 2007 11:59, Evgeniy Polyakov wrote:
> > > > Yes, it is about 98-100% in both cases.
> > > > I've just re-run tests on my amd64 test machine without debug options:
> > > >
> > > > epoll		4794.23
> > > > kevent		6468.95
> > >
> > > It would be valuable if you could post oprofile results
> > > (CPU_CLK_UNHALTED) for both tests.
> >
> > I can't - oprofile does not work on this x86_64 machine:
> >
> 
> Yes, this is a known problem, but you can make it works, as I did.
> 
> Please :)

I can not resist :)

> I used the CVS version of oprofile plus a patch you can find in the mailing 
> list archives. Dont remember exactly, since I hit this some months ago

Could you provide at least remote way to find it?

I only found the same problem at 
http://lkml.org/lkml/2006/10/27/3

but without any hits to solve the problem.

I will try CVS oprofile, if it works I will provide details of course.

My tree is based on rc1 and has this latest commit:
commit b5bf28cde894b3bb3bd25c13a7647020562f9ea0
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Wed Feb 21 11:21:44 2007 -0800

There are no commits after that data with word 'oprofile' in
git-whatchanged at least.

-- 
	Evgeniy Polyakov
