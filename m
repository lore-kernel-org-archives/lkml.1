Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbXEKQwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbXEKQwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXEKQv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:51:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbXEKQv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:51:58 -0400
Date: Fri, 11 May 2007 09:50:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Peter Williams <pwil3058@bigpond.net.au>,
       Esben Nielsen <nielsen.esben@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <20070510130954.GC4052@ucw.cz>
Message-ID: <alpine.LFD.0.98.0705110932430.3986@woody.linux-foundation.org>
References: <463854F3.3020403@linux.vnet.ibm.com> <20070502100545.GA6857@elte.hu>
 <46386F2B.9050307@linux.vnet.ibm.com> <20070502111742.GA18132@elte.hu>
 <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
 <20070506082911.GA32644@elte.hu> <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705071311040.14011@frodo.shire> <463FC5D8.2090502@bigpond.net.au>
 <20070510130954.GC4052@ucw.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-762656802-1178902213=:3986"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-762656802-1178902213=:3986
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT



On Thu, 10 May 2007, Pavel Machek wrote:
> 
> Also notice that current cpus were not designed to work 300 years.
> When we have hw designed for 50 years+, we can start to worry.

Indeed. CPU manufacturers don't seem to talk about it very much, and 
searching for it with google on intel.com comes up with

	The failure rate and Mean Time Between Failure (MTBF) data is not 
	currently available on our website. You may contact Intel® 
	Customer Support for this information.

which seems to be just a fancy way of saying "we don't actually want to 
talk about it". Probably not because it's actually all that bad, but 
simply because people don't think about it, and there's no reason a CPU 
manufacturer would *want* people to think about it.

But if you wondered why server CPU's usually run at a lower frequency, 
it's because of MTBF issues. I think a desktop CPU is usually specced to 
run for 5 years (and that's expecting that it's turned off or at least 
idle much of the time), while a server CPU is expected to last longer and 
be active a much bigger percentage of time.

("Active" == "heat" == "more damage due to atom migration etc". Which is 
part of why you're not supposed to overclock stuff: it may well work well 
for you, but for all you know it will cut your expected CPU life by 90%).

Of course, all the other components have a MTBF too (and I'd generally 
expect a power supply component to fail long before the CPU does). And 
yes, some machines will last for decades. But I suspect we've all heard of 
machines that just don't work reliably any more.

			Linus
---1463790079-762656802-1178902213=:3986--
