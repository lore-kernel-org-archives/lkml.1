Return-Path: <linux-kernel-owner+w=401wt.eu-S1031288AbXDUOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031288AbXDUOza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031291AbXDUOza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:55:30 -0400
Received: from rtr.ca ([64.26.128.89]:4923 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031288AbXDUOz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:55:28 -0400
Message-ID: <462A25DD.2050702@rtr.ca>
Date: Sat, 21 Apr 2007 10:55:25 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <46276BE5.7020001@rtr.ca> <20070420035717.GA1028@wotan.suse.de>
In-Reply-To: <20070420035717.GA1028@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thu, Apr 19, 2007 at 09:17:25AM -0400, Mark Lord wrote:
>> Just plain "make" (no -j2 or -j9999) is enough to kill interactivity
>> on my 2GHz P-M single-core non-HT machine with SD.
> 
> Is this with or without X reniced?

That was with no manual jiggling, everything the same as with stock kernels,
except that stock kernels don't kill interactivity here.

>> But with the very first posted version of CFS by Ingo,
>> I can do "make -j2" no problem and still have a nicely interactive destop.
> 
> How well does cfs run if you have the granularity set to something
> like 30ms (30000000)?

Dunno, I've put this stuff aside for now until things settle down.
With four schedulers, and lots of patches / revisions / tuning-knobs,
there's just no way to keep up with it all here.

Cheers
