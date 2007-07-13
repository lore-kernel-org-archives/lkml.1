Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbXGMMyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbXGMMyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbXGMMyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:54:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:58738 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbXGMMyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:54:45 -0400
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, jim.houston@ccur.com,
       joe.korty@ccur.com, rostedt@goodmis.org, tglx@linutronix.de,
       dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, williams@redhat.com, abogani@texware.it,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070712163341.GA9622@elte.hu>
References: <46961E080200005A000276AE@mcclure.wal.novell.com>
	 <20070712163341.GA9622@elte.hu>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 22:52:55 +1000
Message-Id: <1184331176.6059.225.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 18:33 +0200, Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> >   For the most part, it seems you guys have resolved most of the 
> > issues that we ran into as well (e.g. early-flush-tlb, relocated 
> > die-notifier, etc, come to mind).  I found one patch that was missing 
> > that allows debug configurations to build properly.  Heres that patch:
> > 
> > --- linux-2.6.21.orig/kernel/latency_trace.c
> > +++ linux-2.6.21/kernel/latency_trace.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/utsrelease.h>
> >  #include <asm/uaccess.h>
> >  #include <asm/unistd.h>
> > +#include <asm/asm-offsets.h>
> 
> i think this breaks PPC (which has no asm-offsets.h file). In any case i 
> saw this build breakage too and the fix is in -rt2.

Nah, ppc and powerpc both have asm-offset.h

Cheers,
Ben.

