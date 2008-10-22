Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYJVKJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYJVKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYJVKJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:09:06 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:36560 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbYJVKJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:09:05 -0400
X-BigFish: VPS-32(zz1432R98dR1805M936fO103dKzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K94XIU-01-IXC-01
Date: Wed, 22 Oct 2008 12:08:18 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86: SB600: skip IRQ0 override if it is not routed to INT2 of
	IOAPIC
Message-ID: <20081022100818.GA13407@alberich.amd.com>
References: <20081015095153.GG29098@alberich.amd.com> <20081022100523.GB13400@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081022100523.GB13400@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Oct 2008 10:08:51.0883 (UTC) FILETIME=[2F05F7B0:01C9342E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:05:23PM +0200, Andreas Herrmann wrote:
> On Wed, Oct 15, 2008 at 11:51:53AM +0200, Andreas Herrmann wrote:
> > On some more HP laptops BIOS reports an IRQ0 override
> > but the SB600 chipset is configured such that timer
> > interrupts go to INT0 of IOAPIC.
> > 
> > Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the
> > timer override.
> > 
> > See following bug reports:
> > http://bugzilla.kernel.org/show_bug.cgi?id=11715
> > http://bugzilla.kernel.org/show_bug.cgi?id=11516
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/kernel/early-quirks.c |   55 +++++++++++++++++++++++++++++++++++++--
> >  1 files changed, 52 insertions(+), 3 deletions(-)
> > 
> > Patch is against v2.6.27-3977-gc166ab7 (yesterday's Linus git).
> > Please apply.
> 
> 
> Hi Ingo,
> 
> any chance that this fix makes it into tip asap?
> I'd like to see it in 2.6.28.

Sorry for the noise.
I've just seen that you have already applied it.


Thanks!!

Andreas


