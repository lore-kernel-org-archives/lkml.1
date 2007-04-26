Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXDZLaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXDZLaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbXDZLaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:30:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37834 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754779AbXDZLaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:30:16 -0400
Date: Thu, 26 Apr 2007 13:30:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426113005.GU17387@elf.ucw.cz>
References: <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <1177540027.5025.87.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org> <1177583998.6814.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177583998.6814.42.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > That's where I started: whole "suspend to disk" thing actually has _more_ 
> > to do with "shutdown" than with "suspend". 
> 
> From looking at pm_ops which I was recently working with a lot, it seems
> that it was designed by somebody who was reading the ACPI documentation
> and was otherwise pretty clueless, even at that level std tries to look
> like suspend. IMHO that is one of the first things that should be ripped
> out, no pm_ops for STD, it's a pain to work with.

That code goes back to Patrick, AFAICT. (And yes, ACPI S3 and ACPI S4
low-level enter is pretty similar).

Patches would be welcome, as would be "suspend-to-ram maintainer".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
