Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZDILiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZDILiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 07:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZDILh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 07:37:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:40685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZDILh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 07:37:56 -0400
Subject: Re: [RFC] Static/Runtime CPU/IO bound scheduling polices based on
 CPU(s) to support complete spectrum of tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1239272776.3028.11.camel@ht.satnam>
References: <1239099931.4773.25.camel@ht.satnam>
	 <20090407105835.GP17934@one.firstfloor.org>
	 <1239103951.4773.29.camel@ht.satnam>  <1239272776.3028.11.camel@ht.satnam>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Apr 2009 13:38:19 +0200
Message-Id: <1239277099.7647.345.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 15:56 +0530, Jaswinder Singh Rajput wrote:
> On Tue, 2009-04-07 at 17:02 +0530, Jaswinder Singh Rajput wrote:
> > On Tue, 2009-04-07 at 12:58 +0200, Andi Kleen wrote:
> > > On Tue, Apr 07, 2009 at 03:55:31PM +0530, Jaswinder Singh Rajput wrote:
> > > > I am planning to prepare the followings:
> > > 
> > > This seems all quite vague. Perhaps it would be good if you started
> > > with a clear definition what problem you're trying to solve.
> > > 
> > 
> 
> I do not surprise, if this approach seems vague to many developers
> because this is many years ahead of time.

Yes, or not.

For partitioning we have cpusets, for scheduler policies we have
sched_setscheduler().

The only thing we do not have are deadline schedulers, but people are
working on that -- its a rather complex piece of work.

The rest of you babbling is hand-waving about heuristics.
