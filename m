Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYHZR4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYHZR4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbYHZRz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:55:58 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34506 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755085AbYHZRz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:55:57 -0400
Date: Tue, 26 Aug 2008 13:55:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stefani Seibold <stefani@seibold.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080826175531.GG8720@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stefani Seibold <stefani@seibold.net>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, Dario Faggioli <raistlin@linux.it>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808261954.47987.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de> <200808262127.26803.nickpiggin@yahoo.com.au> <20080826125057.GC8720@mit.edu> <1219757487.31371.19.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219757487.31371.19.camel@matrix>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 03:31:27PM +0200, Stefani Seibold wrote:
> 
> Sorry, the world of embedded programming is sometime stranger than in
> theory. Normally it would not happen that a real-time process locks the
> CPU for more than 1 sec. But in some circumstances, especially FPGA
> initialisation and long term measurements it is possible that the
> real-time process locks the cpu for more than a, sometime for more than
> 10 sec. If the embedded program has designed it in that way, this
> behaviour is desired.
> 

And if that's true, the embedded program can adjust the ulimit to
change the priority levels as appropriately.  Real-time programming
will always required a bit more configuration, such as what priority
various hard and soft interrupt routines will run it.  This is just
one more configuration option. 

> What coming at next? A device driver manager, which kills any driver
> which use to much CPU resource? Or throttle/kicks off the responsible
> driver if the hardware generates to many interrupts?

Actually, we have both of these already.  :-)

						- Ted
