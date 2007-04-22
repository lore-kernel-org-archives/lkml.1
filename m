Return-Path: <linux-kernel-owner+w=401wt.eu-S1030847AbXDVNS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847AbXDVNS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030857AbXDVNS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:18:29 -0400
Received: from rtr.ca ([64.26.128.89]:3076 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030847AbXDVNS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:18:28 -0400
Message-ID: <462B60A1.1020407@rtr.ca>
Date: Sun, 22 Apr 2007 09:18:25 -0400
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
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr> <20070421190026.GA25720@elte.hu>
In-Reply-To: <20070421190026.GA25720@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> 
>>> i've attached it below in a standalone form, feel free to put it 
>>> into SD! :)
>> Assume X went crazy (lacking any statistics, I make the unproven 
>> statement that this happens more often than kthreads going berserk), 
>> then having it niced with minus something is not too nice.
> 
> i've not experienced a 'runaway X' personally, at most it would crash or 
> lock up ;) The value is boot-time and sysctl configurable as well back 
> to 0.
>

Mmmm.. I've had to kill off the odd X that was locking in 100% CPU usage.
In the past, this has happened maybe 1-3 times a year or so on my notebook.

Now mind you, that usage could have been due to some client process,
but X is where the 100% showed up, so X is what I nuked.

Cheers
