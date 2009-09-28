Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZI1QgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZI1QgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZI1QgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:36:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60904 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZI1QgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:36:13 -0400
Date: Mon, 28 Sep 2009 18:36:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31: booting on a PIII Celeron?
Message-ID: <20090928163617.GA25503@atrey.karlin.mff.cuni.cz>
References: <4AC0D59F.8000502@msgid.tls.msk.ru> <4AC0D651.7030009@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC0D651.7030009@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Michael Tokarev wrote:
> >Hello.
> >I've a problem here with 2.6.31.  kernel is
> >compiled for PIII:
> >
> > CONFIG_MPENTIUMIII=y
> > CONFIG_X86_GENERIC=y
> >
> >This kernel works on real PIII machine - like this:
> >
> >vendor_id    : GenuineIntel
> >cpu family    : 6
> >model        : 8
> >model name    : Pentium III (Coppermine)
> >stepping    : 10
> >cpu MHz        : 997.580
> >
> >But it fails on a Celeron:
> >
> >vendor_id    : GenuineIntel
> >cpu family    : 6
> >model        : 8
> >model name    : Celeron (Coppermine)
> >stepping    : 6
> >cpu MHz        : 797.481
> >
> 
> There's one more difference between the two:
> 
> PIII, working:
> flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 
> mmx fxsr sse up
> Celeron, !working:
> flags: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pse36 mmx 
> fxsr sse up
> 
> So the celeron machine lacks "apic" flag.  And in my
> kernel config, apic is enabled:
>  CONFIG_X86_LOCAL_APIC=y
>  CONFIG_X86_IO_APIC=y
> (but not on the command line like apic=force)
try 'noapic nolapic' to see if it helps?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
