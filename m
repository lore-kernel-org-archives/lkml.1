Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbYAJAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbYAJAKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYAJAKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:10:03 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:38615 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYAJAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:10:00 -0500
Date: Wed, 9 Jan 2008 19:09:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: john stultz <johnstul@us.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
 delays
In-Reply-To: <1199923219.6350.16.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0801091908470.5270@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org>  <20080109233044.288563621@goodmis.org>
 <1199923219.6350.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 Jan 2008, john stultz wrote:
> > ---
> >  arch/x86/kernel/vsyscall_64.c |    5 ++-
> >  include/asm-x86/vgtod.h       |    2 -
> >  include/linux/clocksource.h   |   58 ++++++++++++++++++++++++++++++++++++++++--
> >  kernel/time/timekeeping.c     |   35 +++++++++++++------------
> >  4 files changed, 80 insertions(+), 20 deletions(-)
> >
> > linux-2.6.21-rc5_cycles-accumulated_C7.patch
>             ^^ An oldie but a goodie?

Hehe, I got this directly from the RT queue.

>
> I was just reminded that in the time since 2.6.21-rc5, other arches
> beside x86_64 have gained vgettimeofday implementations, and thus will
> need similar update_vsyscall() tweaks as seen below to get the correct
> time.
>
> Here's the fix for x86_64:

Thanks! I'll fold this into this patch for the next release.

-- Steve
