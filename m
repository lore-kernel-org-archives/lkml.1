Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbXCaQgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbXCaQgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXCaQgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:36:44 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44509 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbXCaQgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:36:44 -0400
Date: Sat, 31 Mar 2007 09:36:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
Message-ID: <20070331163600.GY10574@sequoia.sous-sol.org>
References: <20070331083149.997762000@sous-sol.org> <20070331092339.GA2033@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331092339.GA2033@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> * Chris Wright <chrisw@sous-sol.org> wrote:
> > This series converts x86_64 timers to clockevents drivers and then 
> > enables dynticks.  There's some minor cleanups along the way.  The 
> > lapic broadcast mechanism is untested, I'm sure it still needs work, 
> > there's still some cruft in lapic_setup_timer.
> > 
> > This is just for comments at this point, now that it's working on my 
> > test box in both NO_HZ=n and NO_HZ=n configurations (typically using 
> > hpet).
> 
> hm, neat - did you take a look at the x86_64 clockevents code that is in 
> -rt and that has been there for a year or so and has been tested quite 
> extensively?

Yes, that's what I started with.  It was only partially done, for example,
didn't have hpet done yet and didn't work well on my machine (hang
on boot).  As I dug at it, there was still more room for cleanups, etc.
Hence this, which has also been tested somewhat extensively as Jeremy
noted from my typo above...  Both NO_HZ=n _and_ NO_HZ=n ;-)

thanks,
-chris
