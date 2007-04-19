Return-Path: <linux-kernel-owner+w=401wt.eu-S1766669AbXDSNR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766669AbXDSNR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766684AbXDSNR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:17:29 -0400
Received: from rtr.ca ([64.26.128.89]:1050 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766669AbXDSNR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:17:28 -0400
Message-ID: <46276BE5.7020001@rtr.ca>
Date: Thu, 19 Apr 2007 09:17:25 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org>
In-Reply-To: <200704192159.35546.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
s go ahead and think up great ideas for other ways of metering out cpu 
> bandwidth for different purposes, but for X, given the absurd simplicity of 
> renicing, why keep fighting it? Again I reiterate that most users of SD have 
> not found the need to renice X anyway except if they stick to old habits of 
> make -j4 on uniprocessor and the like, and I expect that those on CFS and 
> Nicksched would also have similar experiences.

Just plain "make" (no -j2 or -j9999) is enough to kill interactivity
on my 2GHz P-M single-core non-HT machine with SD.

But with the very first posted version of CFS by Ingo,
I can do "make -j2" no problem and still have a nicely interactive destop.

-ml
