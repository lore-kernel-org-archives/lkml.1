Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbXDAS5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbXDAS5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933898AbXDAS5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:57:53 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39524 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933897AbXDAS5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:57:52 -0400
Date: Sun, 1 Apr 2007 11:54:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
Message-ID: <20070401185402.GZ10574@sequoia.sous-sol.org>
References: <20070331083149.997762000@sous-sol.org> <1175419332.28263.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175419332.28263.67.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Sat, 2007-03-31 at 01:31 -0700, Chris Wright wrote:
> > This series converts x86_64 timers to clockevents drivers
> > and then enables dynticks.  There's some minor cleanups along
> > the way.  The lapic broadcast mechanism is untested, I'm sure it
> > still needs work, there's still some cruft in lapic_setup_timer.
> > 
> > This is just for comments at this point, now that it's working
> > on my test box in both NO_HZ=n and NO_HZ=n configurations (typically
> > using hpet).
> 
> Have you checked, if we could share the code between i386 and x86_64 at
> least for PIT and HPET. I'm not sure about the local APIC, but I think
> it might be doable as well.

Yes, that's part of why I did some of the cleanups that way, so that we
could merge the two together later.

thanks,
-chris
