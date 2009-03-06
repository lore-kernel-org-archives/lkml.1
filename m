Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZCFGiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZCFGiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZCFGiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:38:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:35555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751303AbZCFGiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:38:03 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+sqi5SkmysJpm7XlJANF8cGnsVxRJJ3Lf1f5DAG/
	pQLoqj1/cihtts
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Mike Galbraith <efault@gmx.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236283315.6457.4.camel@localhost.localdomain>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
	 <1236279393.3316.13.camel@localhost.localdomain>
	 <1236281661.5187.432.camel@laptop>  <20090305194127.GA2039@elte.hu>
	 <1236283315.6457.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 07:37:53 +0100
Message-Id: <1236321473.6030.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 01:31 +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-05 at 20:41 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2009-03-06 at 00:26 +0530, Jaswinder Singh Rajput wrote:
> > > 
> > > > But kerneltop is still not working and I am not getting any NMI Interrupts.
> > > 
> > > Does the below work for you?
> > > 
> > > The BKGD suggests its 48 for all existing machines (it 
> > > certainly is for mine).
> > 
> > Yeah, this did the trick on AMD/Barcelona!
> > 
> 
> Nice.
> 
> but on my AMD box I got interrupts and NMI for some time:
> 
> NMI:        100    1108209   Non-maskable interrupts
> LOC:        213     192815   Local timer interrupts
> CNT:        100    1108206   Performance counter interrupts
> RES:      21132      20397   Rescheduling interrupts
> 
> but kerneltop does not show anything, it only shows # irqs/sec for some
> time and then irqs also become 0.

Hm.  Kerneltop on my Q6600 has ceased to function with n 1 as well, but
n 0 still works.  Zero NMIs.

Perfstat has also gone south.
perfstat: perfstat.c:423: main: Assertion `res == sizeof(single_count)' failed.

	-Mike

