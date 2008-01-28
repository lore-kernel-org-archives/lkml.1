Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYA1Nmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYA1Nmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYA1Nml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:42:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36410 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYA1Nmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:42:40 -0500
Date: Mon, 28 Jan 2008 13:40:56 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, rth@twiddle.net,
       bryan.wu@analog.com, dhowells@redhat.com, gerg@uclinux.org,
       lethal@linux-sh.org, wli@holomorphy.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 2/2] xtime_lock vs update_process_times
Message-ID: <20080128134056.GA2792@flint.arm.linux.org.uk>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>, rth@twiddle.net,
	bryan.wu@analog.com, dhowells@redhat.com, gerg@uclinux.org,
	lethal@linux-sh.org, wli@holomorphy.com, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	tglx@linutronix.de, mingo@elte.hu, torvalds@linux-foundation.org
References: <20080128103953.326762000@chello.nl> <20080128104056.184943000@chello.nl> <20080128122030.GA14058@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128122030.GA14058@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 12:20:30PM +0000, Russell King wrote:
> On Mon, Jan 28, 2008 at 11:39:55AM +0100, Peter Zijlstra wrote:
> > move update_process_times() out from under xtime_lock.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Peter,
> 
> Mind if I merge:
> 
> >  arch/arm/common/time-acorn.c          |    2 --
> >  arch/arm/mach-at91/at91sam926x_time.c |    3 ---
> >  arch/arm/plat-iop/time.c              |    4 ----
> >  arch/arm/plat-s3c24xx/time.c          |    2 --
> 
> with my patch and submit it as part of the ARM merge (which I'm hoping
> to send in about an hours time.)

Don't bother - I'm sending my patch _now_ - I've run out of time to 
merge the above into this ARM tree pull (since I want to get Linus to
pull it before yet more breakage happens to it - I've had to drop a
number of branches with new conflicts as of last night to even get this
far...)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
