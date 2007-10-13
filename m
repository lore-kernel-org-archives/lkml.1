Return-Path: <linux-kernel-owner+w=401wt.eu-S1763278AbXJMXQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763278AbXJMXQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 19:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbXJMXQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 19:16:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36527 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbXJMXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 19:16:19 -0400
Subject: Re: [PATCH] sched: high-res preemption tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192317228.5625.8.camel@lappy>
References: <1192222309.5897.3.camel@lappy>
	 <1192259938.7369.4.camel@Homer.simpson.net>
	 <1192265717.27435.44.camel@twins>  <1192267072.5897.5.camel@lappy>
	 <1192317228.5625.8.camel@lappy>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 01:16:06 +0200
Message-Id: <1192317366.5625.9.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-14 at 01:13 +0200, Peter Zijlstra wrote:
> On Sat, 2007-10-13 at 11:17 +0200, Peter Zijlstra wrote:
> 
> > > Ah, but HRTICK is not compatible with PREEMPT_RESTRICT, it will be
> > > similar to !WAKEUP_PREEMPT.
> > 
> > (I do plan to fix that eventually, just need to do it)
> 
> I guess something like this ought to do, but its a tad late so I'm quite
> sure :-)

I guess that proves it.... that should have read: 
  ... so I'm _not_ quite sure.


