Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXDVNai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXDVNai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXDVNai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:30:38 -0400
Received: from rtr.ca ([64.26.128.89]:3631 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbXDVNah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:30:37 -0400
Message-ID: <462B637A.5080304@rtr.ca>
Date: Sun, 22 Apr 2007 09:30:34 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Con Kolivas <kernel@kolivas.org>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr> <20070421190026.GA25720@elte.hu> <462B60A1.1020407@rtr.ca> <20070422132732.GB18471@elte.hu>
In-Reply-To: <20070422132732.GB18471@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> well, i just simulated a runaway X at nice -19 on CFS (on a UP box), and 
> while the box was a tad laggy, i was able to killall it without 
> problems, within 2 seconds that also included a 'su'. So it's not an 
> issue in CFS, it can be turned off, and because every distro has another 
> way to renice Xorg, this is a convenience hack until Xorg standardizes 
> it into some xorg.conf field. (It also makes sure that X isnt preempted 
> by other userspace stuff while it does timing-sensitive operations like 
> setting the video modes up or switching video modes, etc.)

Good!
