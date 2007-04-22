Return-Path: <linux-kernel-owner+w=401wt.eu-S1030726AbXDVMyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030726AbXDVMyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030765AbXDVMyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:54:32 -0400
Received: from rtr.ca ([64.26.128.89]:3415 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030726AbXDVMyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:54:32 -0400
Message-ID: <462B5B04.3060309@rtr.ca>
Date: Sun, 22 Apr 2007 08:54:28 -0400
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
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <46276BE5.7020001@rtr.ca> <20070420035717.GA1028@wotan.suse.de> <462A25DD.2050702@rtr.ca>
In-Reply-To: <462A25DD.2050702@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just to throw another possibly-overlooked variable into the mess:

My system here is using the on-demand cpufreq policy governor.
I wonder how that interacts with the various schedulers here?

I suppose for the "make" kernel case, after a couple of seconds
the cpufreq would hit max and stay there for the rest of the build,
so it shouldn't really be a factor for (non-)interactivity during the build.

Or should it?

Cheers
