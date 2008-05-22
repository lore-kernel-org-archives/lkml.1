Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYEVSaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYEVSaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYEVSaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:30:09 -0400
Received: from www.tglx.de ([62.245.132.106]:44440 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYEVSaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:30:08 -0400
Date: Thu, 22 May 2008 20:29:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] x86: Timer through APIC and related clean-ups
In-Reply-To: <Pine.LNX.4.55.0805212158350.4894@cliff.in.clinika.pl>
Message-ID: <alpine.LFD.1.10.0805222029020.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.55.0805212158350.4894@cliff.in.clinika.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Maciej W. Rozycki wrote:
> Hello,
> 
>  This is a set of patches replacing patch-2.6.26-rc1-20080505-timer_ack-1
> and patch-2.6.26-rc1-20080505-timer-8259-0 sent previously.  The patches
> have been split up into smaller logically self-contained chunks to make
> tracking down problems easier.
> 
>  The patch-2.6.26-rc1-20080505-nosmp-watchdog-0 change fixes a problem
> with timer interrupts getting masked in the 8259A as a result of
> patch-2.6.26-rc1-20080505-timer-8259-6 in the corner-case scenario of
> "nmi_watchdog=1 nosmp" being passed at the command line.
> 
>  As there are some interdependencies the patches are best applied in the 
> order I am sending them; see also the paragraph above.

Looks really good. Applied. Thanks,

	 tglx
