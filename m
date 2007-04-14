Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXDNT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXDNT6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXDNT6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:58:17 -0400
Received: from holomorphy.com ([66.93.40.71]:60835 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXDNT6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:58:16 -0400
Date: Sat, 14 Apr 2007 12:55:53 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: surya.prabhakar@wipro.com, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, npiggin@suse.de, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de
Subject: Re: [TEST RESULT]massive_intr.c -- cfs/vanilla/sd-0.40
Message-ID: <20070414195553.GA2986@holomorphy.com>
References: <1176540546.2702.15.camel@bluegenie> <20070414120220.GA2346@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414120220.GA2346@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 02:02:20PM +0200, Ingo Molnar wrote:
> cool. ringtest.c is intended to be used the following way: start it, it 
> will generate a 99% busy system (but it is using a ring of 100 tasks, 
> where each tasks runs for 100 msecs then sleeps for 1 msec, so every 
> task gets a turn every 10 seconds). If you add a pure CPU hog to the 
> system, for example an infinite shell loop:
> 	while :; do :; done &
> then a 'fair' scheduler would give roughly 50% of CPU time to the CPU 
> hog (and the ringtest.c tasks take up the other 50%).

I've queued up modifying ringtest.c to automatically spawn a CPU hog
and then report aggregate CPU bandwidth of the ring and the bandwidth
of the CPU hog as work to do at some point. I've no guarantee I'll get
to it in a timely fashion, though.


-- wli
