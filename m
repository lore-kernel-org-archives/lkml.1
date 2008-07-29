Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYG2KYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYG2KYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYG2KYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:24:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:45725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYG2KYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:24:00 -0400
Subject: Re: x86: Is there still value in having a special tlb flush IPI
	vector?
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <200807292017.42005.nickpiggin@yahoo.com.au>
References: <488E534F.2030204@goop.org>
	 <200807292000.30690.nickpiggin@yahoo.com.au>
	 <1217325853.7563.5.camel@twins>
	 <200807292017.42005.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 12:23:43 +0200
Message-Id: <1217327023.7563.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 20:17 +1000, Nick Piggin wrote:
> On Tuesday 29 July 2008 20:04, Peter Zijlstra wrote:
> > On Tue, 2008-07-29 at 20:00 +1000, Nick Piggin wrote:
> > > On Tuesday 29 July 2008 19:54, Peter Zijlstra wrote:
> > > > On Tue, 2008-07-29 at 14:30 +1000, Nick Piggin wrote:
> > > > > Not to mention the minor problem that it still deadlocks when called
> > > > > with interrupts disabled ;)
> > > >
> > > > __smp_call_function_single has potential though..
> > >
> > > For reschedule interrupt? I don't really agree.
> >
> > Not specifically, for not deadlocking from irq-off, more so.
> 
> Oh, well yes it already does work from irq-off, so it has already
> realised its potential :)
> 
> Not sure exactly what kinds of users it is going to attract, but
> it should be interesting to see!

grep __smp_call_function_single kernel/sched.c


