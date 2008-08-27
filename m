Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYH0LXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYH0LXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYH0LXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:23:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36100 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbYH0LX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:23:29 -0400
Date: Wed, 27 Aug 2008 12:17:26 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Gregory Haskins <ghaskins@novell.com>,
       mingo@elte.hu, srostedt@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, gregory.haskins@gmail.com,
       ralf@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
Message-ID: <20080827111726.GA2914@flint.arm.linux.org.uk>
References: <20080826173131.16413.17862.stgit@dev.haskins.net> <20080826173500.16413.40514.stgit@dev.haskins.net> <1219825295.6462.54.camel@twins> <20080827102646.GA5818@wotan.suse.de> <1219833668.6462.72.camel@twins> <20080827105615.GB5818@wotan.suse.de> <1219835224.6462.81.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219835224.6462.81.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 01:07:04PM +0200, Peter Zijlstra wrote:
> On Wed, 2008-08-27 at 12:56 +0200, Nick Piggin wrote:
> 
> > BTW. I wonder about other architectures that are of interest to -rt? Like
> > mips or arm perhaps... Any plans to implement ticket locks on those, or
> > do they not tend to be used in SMP configurations on -rt yte?
> 
> I think both are starting to show more and more SMP machines, so yes,
> eventually we'll want ticket locks for them too.
> 
> That said, I'm not aware of anyone working on it - I suppose we could
> poke the regular arch maintainers.. Ralf, Russell ?

I've no idea; SMP on ARM as far as I've been involved has been silent
for well over a year with very little visible interest from anyone.
That's situation normal for things that "just work" though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
