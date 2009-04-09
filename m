Return-Path: <linux-kernel-owner+w=401wt.eu-S933524AbZDIK2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524AbZDIK2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZDIK2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:28:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:43327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbZDIK2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:28:23 -0400
Subject: Re: [RFC] Static/Runtime CPU/IO bound scheduling polices based on
 CPU(s) to support complete spectrum of tasks
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1239103951.4773.29.camel@ht.satnam>
References: <1239099931.4773.25.camel@ht.satnam>
	 <20090407105835.GP17934@one.firstfloor.org>
	 <1239103951.4773.29.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 15:56:16 +0530
Message-Id: <1239272776.3028.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 17:02 +0530, Jaswinder Singh Rajput wrote:
> On Tue, 2009-04-07 at 12:58 +0200, Andi Kleen wrote:
> > On Tue, Apr 07, 2009 at 03:55:31PM +0530, Jaswinder Singh Rajput wrote:
> > > I am planning to prepare the followings:
> > 
> > This seems all quite vague. Perhaps it would be good if you started
> > with a clear definition what problem you're trying to solve.
> > 
> 

I do not surprise, if this approach seems vague to many developers
because this is many years ahead of time.

If you can see the future, then you can see in next few years we will
get single processor with hundreds of symmetrical and asymmetrical cores
then we need to treat each core as a different system and each core will
be dedicated for specific use and task and we need different scheduling
polices for each core.

Even in embedded space, hundreds of small asymmetrical processors will
be compact into a single die to save power, space, communication and so
on.

> This will solves 2 major problems:
> 
> 1. Support complete task spectrum (Hard/soft/non Realtime) on one
> system.
> 
> 2. Take Maximum advantage of the each CPU core and treat each CPU core
> as a System. So we can take maximum utilization of the Hardware.

Further more this will create healthy competition in different
schedulers. And then we can see which scheduler is best for which case.

--
JSR

