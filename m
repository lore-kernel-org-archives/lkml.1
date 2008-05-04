Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYEDEa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYEDEa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 00:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYEDEar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 00:30:47 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:50736 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYEDEaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 00:30:46 -0400
Date: Sun, 4 May 2008 10:00:30 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       guichaz@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, efault@gmx.de
Subject: Re: [RFC][PATCH] sched_clock_cpu()
Message-ID: <20080504043030.GA21789@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1209832169.6929.42.camel@lappy> <20080503165511.GA21967@elte.hu> <20080503173023.GA2394@linux.vnet.ibm.com> <20080503.211646.250661233.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503.211646.250661233.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 09:16:46PM -0700, David Miller wrote:
> From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Date: Sat, 3 May 2008 23:00:23 +0530
> 
> > On Sat, May 03, 2008 at 06:55:11PM +0200, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > it _DOESN'T_ boot ;-/ [...]
> > > 
> > > FYI, the merged version against sched-devel.git does boot fine here and 
> > > the clock does seem to advance as expected.
> > > 
> > 
> > boots here against linus as well.
> 
> If you tested on powerpc (just guessing), did you set
> HAVE_STABLE_CLOCK in arch/powerpc/Kconfig?  That's
> what you'll need to do to take advantage of the
> new code.

I was testing on x86. Let me boot it on a powerpc box, and give feedback
(I was more interested in getting it boot the first time and it was
already late :) )

-- 
regards,
Dhaval
