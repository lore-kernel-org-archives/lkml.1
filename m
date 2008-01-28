Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbYA1Mae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbYA1Mae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYA1MaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:30:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYA1MaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:30:24 -0500
Subject: Re: [RFC][PATCH 2/2] xtime_lock vs update_process_times
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: rth@twiddle.net, bryan.wu@analog.com, dhowells@redhat.com,
       gerg@uclinux.org, lethal@linux-sh.org, wli@holomorphy.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       torvalds@linux-foundation.org
In-Reply-To: <20080128122030.GA14058@flint.arm.linux.org.uk>
References: <20080128103953.326762000@chello.nl>
	 <20080128104056.184943000@chello.nl>
	 <20080128122030.GA14058@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 13:29:33 +0100
Message-Id: <1201523373.28547.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 12:20 +0000, Russell King wrote:
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

not at all, please do :-)

