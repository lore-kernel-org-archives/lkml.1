Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXCATTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXCATTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965518AbXCATTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:19:36 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1929 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965513AbXCATTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:19:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 1 Mar 2007 11:19:30 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
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
In-Reply-To: <20070301095402.GA14603@elte.hu>
Message-ID: <Pine.LNX.4.64.0703011118220.23932@alien.or.mcafeemobile.com>
References: <20070226172812.GC22454@2ka.mipt.ru>
 <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org>
 <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru>
 <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru>
 <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru>
 <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru>
 <20070301095402.GA14603@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007, Ingo Molnar wrote:

> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > I posted kevent/epoll benchmarks and related design issues too many 
> > times both with handmade applications (which might be broken as hell) 
> > and popular open-source servers to repeat them again.
> 
> numbers are crutial here - and given the epoll bugs in the evserver code 
> that we found, do you have updated evserver benchmark results that 
> compare epoll to kevent? I'm wondering why epoll has half the speed of 
> kevent in those measurements - i suspect some possible benchmarking bug. 
> The queueing model of epoll and kevent is roughly comparable, both do 
> only a constant number of steps to serve one particular request, 
> regardless of how many pending connections/requests there are. What is 
> the CPU utilization of the server system during an epoll test, and what 
> is the CPU utilization during a kevent test? 100% utilized in both 
> cases?

With 8K concurrent (live) connections, we may also want to try with the v3 
version of the epoll-event-loops-diet patch ;)



- Davide


