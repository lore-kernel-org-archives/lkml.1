Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZGVVkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZGVVkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZGVVkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:40:53 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:43088 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZGVVkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:40:52 -0400
Date: Wed, 22 Jul 2009 14:39:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
Message-ID: <20090722213942.GA4337@josh-work.beaverton.ibm.com>
References: <1247873945.8334.67.camel@localhost.localdomain>
 <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
 <1247954978.14494.19.camel@work-vm>
 <20090718153011.1de3af8e@infradead.org>
 <1248088622.15751.8465.camel@twins>
 <20090720063305.2ad49d40@infradead.org>
 <1248097754.15751.8867.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248097754.15751.8867.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 03:49:14PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-20 at 06:33 -0700, Arjan van de Ven wrote:
> > > Maybe power64, sparc64 and s390x qualify, but certainly nothing on x86
> > > does.
> > 
> > the x86 on my desk disagrees.
> 
> >From what I know even nehalem doesn't have fully synced tscs when your
> machine is large enough, and the timers are still a tad expensive.

All single-socket Nehalem boards have synced TSCs, and some multi-socket
Nehalem boards have synced TSCs, notably Intel's.  I don't know if you
can safely rely on the latter, though.

> Maybe your desktop is next-gen? 't would be nice to finally have an x86
> that has usable clock and timer hardware.

x86 CPUs with the ARAT feature ("always running APIC timer") will let
you use the local APIC even in deep C-states.  I don't know about the
overhead of the local APIC.

- Josh Triplett
