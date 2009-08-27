Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbZH0Wpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbZH0Wpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZH0Wpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:45:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZH0Wpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:45:36 -0400
Date: Thu, 27 Aug 2009 18:45:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] lockup with the latest kernel
In-Reply-To: <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0908271844240.26718@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com> <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Steven Rostedt wrote:
> > 
> > Always happens where one CPU is sending an IPI and the other has the rq 
> > spinlock. Seems to be that the IPI expects the other CPU to not have 
> > interrupts disabled or something?
> > 
> > Note, I've seen this on 2.6.30-rc6 as well (yes that's 2.6.30). But this 
> > does not happen on 2.6.29. Unfortunately, 2.6.29 makes my NIC go kaputt 
> > for some reason.

Clearification, it did happen on 2.6.29, I thought I was running 29, but 
it turned out, my previous kernel was 27.

-- Steve

