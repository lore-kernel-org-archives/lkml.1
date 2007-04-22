Return-Path: <linux-kernel-owner+w=401wt.eu-S1030868AbXDVNXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030868AbXDVNXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030874AbXDVNXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:23:54 -0400
Received: from rtr.ca ([64.26.128.89]:3591 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030868AbXDVNXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:23:54 -0400
Message-ID: <462B61E7.8050607@rtr.ca>
Date: Sun, 22 Apr 2007 09:23:51 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org>
In-Reply-To: <200704220959.34978.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
>
> Oh I definitely was not advocating against renicing X, I just suspect that 
> virtually all the users who gave glowing reports to CFS comparing it to SD 
> had no idea it had reniced X to -19 behind their back and that they were 
> comparing it to SD running X at nice 0.

I really do wish I wouldn't feel the need to keep stepping in here
to manually exclude my own results from such wide brush strokes.

I'm one of those "users", and I've never even tried CFS v4 (yes).
All prior versions did NOT do the renicing.

The renicing was in the CFS v4 announcement, right up front for all to see,
and the code for it has been posted separately with encouragement for RSDL
or whatever to also adopt it.

Now, with it in all of the various "me-too" schedulers,
maybe they'll all start to shine a little more on real users' systems.
So far, the stock 2.6.20 scheduler remains my own current preference,
despite really good results with CFS v1.

Cheers

