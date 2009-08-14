Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZHNOJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZHNOJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 10:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbZHNOJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 10:09:24 -0400
Received: from www.tglx.de ([62.245.132.106]:49229 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZHNOJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 10:09:23 -0400
Date: Fri, 14 Aug 2009 16:08:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 00/15] clocksource / timekeeping rework V4 (resend V3 +
 bug fix)
In-Reply-To: <20090814134717.859098725@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0908141608120.1283@localhost.localdomain>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin,

On Fri, 14 Aug 2009, Martin Schwidefsky wrote:

> Greetings,
> version 4 of the clocksource / timekeeping cleanup patches. If you
> wonder why version 3 did not show up on the mailing list: I had a
> hiccup with quilt which did strange things to the message ids and
> the post to lkml got rejected. Sorry for the spamming of the people
> on Cc.
> 
> John pointed out a subtle bug in v3 of the patch set with the reset of
> the cycle_last value in timekeeping_resume. Fixed in v4.
> 
> The latest additions are:
> 1) Change read_persistent_clock to return a struct timespec instead of
>    an unsigned long with the number of seconds.
> 2) Introduce read_boot_clock to initialize wall_to_monotonic.
> 3) Move the reset of cycle_last to zero from the timekeeping code to
>    the TSC code.
> 
> The patch set is based on todays upstream tree plus the patches from
> the tip tree, if anyone wants to try them you need to pull from the
> master branch of
>     git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip
> 
> Keeping the fingers crossed that this is now really done.
> John already gave his thumbs up for the patch series, so the next
> logical question is who is going to sit on the patches until the merge
> window is opened? I can certainly create a git branch on git390 for
> them, but the patches depend on some patches in the x86-tip tree.
> Thomas, any thoughts?

I'm going through them and pick them up into -tip.

Thanks,

	tglx
