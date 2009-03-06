Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZCFGv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZCFGv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZCFGvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:51:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:39924 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751362AbZCFGvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:51:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19oGid+wFlousW3RvnmnIWRDqcR86koyFe2PCh0GR
	bzn5BKf/lXdzaX
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Mike Galbraith <efault@gmx.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236321473.6030.8.camel@marge.simson.net>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
	 <1236279393.3316.13.camel@localhost.localdomain>
	 <1236281661.5187.432.camel@laptop>  <20090305194127.GA2039@elte.hu>
	 <1236283315.6457.4.camel@localhost.localdomain>
	 <1236321473.6030.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 07:51:40 +0100
Message-Id: <1236322300.6263.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 07:37 +0100, Mike Galbraith wrote:
> On Fri, 2009-03-06 at 01:31 +0530, Jaswinder Singh Rajput wrote:
> > On Thu, 2009-03-05 at 20:41 +0100, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Fri, 2009-03-06 at 00:26 +0530, Jaswinder Singh Rajput wrote:
> > > > 
> > > > > But kerneltop is still not working and I am not getting any NMI Interrupts.
> > > > 
> > > > Does the below work for you?
> > > > 
> > > > The BKGD suggests its 48 for all existing machines (it 
> > > > certainly is for mine).
> > > 
> > > Yeah, this did the trick on AMD/Barcelona!
> > > 
> > 
> > Nice.
> > 
> > but on my AMD box I got interrupts and NMI for some time:
> > 
> > NMI:        100    1108209   Non-maskable interrupts
> > LOC:        213     192815   Local timer interrupts
> > CNT:        100    1108206   Performance counter interrupts
> > RES:      21132      20397   Rescheduling interrupts
> > 
> > but kerneltop does not show anything, it only shows # irqs/sec for some
> > time and then irqs also become 0.
> 
> Hm.  Kerneltop on my Q6600 has ceased to function with n 1 as well, but
> n 0 still works.  Zero NMIs.
> 
> Perfstat has also gone south.
> perfstat: perfstat.c:423: main: Assertion `res == sizeof(single_count)' failed.

Ah, my woes are gonna be 2743a5b0fa6f309da904f2190a9cc25deee34dbd.

Never mind.

	-Mike

