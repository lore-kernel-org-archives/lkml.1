Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXDTFGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXDTFGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXDTFGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:06:46 -0400
Received: from 1wt.eu ([62.212.114.60]:2049 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbXDTFGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:06:45 -0400
Date: Fri, 20 Apr 2007 07:05:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jan Knutar <jk-lkml@sci.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070420050510.GA31637@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu> <200704200252.39459.jk-lkml@sci.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704200252.39459.jk-lkml@sci.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 02:52:38AM +0300, Jan Knutar wrote:
> On Thursday 19 April 2007 18:18, Ingo Molnar wrote:
> > * Willy Tarreau <w@1wt.eu> wrote:
> > > You can certainly script it with -geometry. But it is the wrong
> > > application for this matter, because you benchmark X more than
> > > glxgears itself. What would be better is something like a line
> > > rotating 360 degrees and doing some short stuff between each
> > > degree, so that X is not much sollicitated, but the CPU would be
> > > spent more on the processes themselves.
> >
> > at least on my setup glxgears goes via DRI/DRM so there's no X
> > scheduling inbetween at all, and the visual appearance of glxgears is
> > a direct function of its scheduling.
> 
> How much of the subjective interactiveness-feel of the desktop is at the 
> mercy of the X server's scheduling and not the cpu scheduler?

probably a lot. Hence the reason why I wanted something visually noticeable
but using far less X resources than glxgears. The modified orbitclock is
perfect IMHO.

Regards,
Willy

