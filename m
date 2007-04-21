Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbXDUXRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbXDUXRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXDUXRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:17:42 -0400
Received: from holomorphy.com ([66.93.40.71]:38253 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbXDUXRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:17:41 -0400
Date: Sat, 21 Apr 2007 16:17:43 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421231743.GG2986@holomorphy.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu> <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org> <20070421164241.GF2986@holomorphy.com> <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com> <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
>> It might be nice if it was possible to actively contribute your CPU
>> time to a child process.  For example:
>> int sched_donate(pid_t pid, struct timeval *time, int percentage);

On Sat, Apr 21, 2007 at 12:49:52PM -0700, Ulrich Drepper wrote:
> If you do this, and it has been requested many a times, then please
> generalize it.  We have the same issue with futexes.  If a FUTEX_WAIT
> call is issues the remaining time in the slot should be given to the
> thread currently owning the futex.  For non-PI futexes this needs an
> extension of the interface but I would be up for that.  It can have
> big benefits on the throughput of an application.

It's encouraging to hear support for a more full-featured API (or, for
that matter, any response at all) on this front.


-- wli
