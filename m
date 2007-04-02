Return-Path: <linux-kernel-owner+w=401wt.eu-S965949AbXDBVbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965949AbXDBVbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965951AbXDBVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:31:37 -0400
Received: from www.osadl.org ([213.239.205.134]:34481 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965949AbXDBVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:31:36 -0400
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070401185402.GZ10574@sequoia.sous-sol.org>
References: <20070331083149.997762000@sous-sol.org>
	 <1175419332.28263.67.camel@localhost.localdomain>
	 <20070401185402.GZ10574@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 23:31:44 +0200
Message-Id: <1175549504.28263.184.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 11:54 -0700, Chris Wright wrote:
> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > On Sat, 2007-03-31 at 01:31 -0700, Chris Wright wrote:
> > > This series converts x86_64 timers to clockevents drivers
> > > and then enables dynticks.  There's some minor cleanups along
> > > the way.  The lapic broadcast mechanism is untested, I'm sure it
> > > still needs work, there's still some cruft in lapic_setup_timer.
> > > 
> > > This is just for comments at this point, now that it's working
> > > on my test box in both NO_HZ=n and NO_HZ=n configurations (typically
> > > using hpet).
> > 
> > Have you checked, if we could share the code between i386 and x86_64 at
> > least for PIT and HPET. I'm not sure about the local APIC, but I think
> > it might be doable as well.
> 
> Yes, that's part of why I did some of the cleanups that way, so that we
> could merge the two together later.

I'd prefer to get this done now. If we plug it in as is, the "merge
later" probably will never happen.

	tglx


