Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbXEQVtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbXEQVtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEQVs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:48:59 -0400
Received: from d06184b1.dreamhost.com ([208.97.132.177]:56308 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755961AbXEQVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:48:58 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v13
Date: Fri, 18 May 2007 03:17:03 +0530
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070517174533.GA538@elte.hu>
In-Reply-To: <20070517174533.GA538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705180317.06014.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 23:15:33 Ingo Molnar wrote:
> i'm pleased to announce release -v13 of the CFS scheduler patchset.
>
> The CFS patch against v2.6.22-rc1, v2.6.21.1 or v2.6.20.10 can be
> downloaded from the usual place:
>
>      http://people.redhat.com/mingo/cfs-scheduler/
>
> -v13 is a fixes-only release. It fixes a smaller accounting bug, so if
> you saw small lags during desktop use under certain workloads then
> please re-check that workload under -v13 too. It also tweaks SMP
> load-balancing a bit. (Note: the load-balancing artifact reported by
> Peter Williams is not a CFS-specific problem and he reproduced it in
> v2.6.21 too. Nevertheless -v13 should be less prone to such artifacts.)
>
> I know about no open CFS regression at the moment, so please re-test
> -v13 and if you still see any problem please re-report it. Thanks!
>
> Changes since -v12:
>
>  - small tweak: made the "fork flow" of reniced tasks zero-sum
>
>  - debugging update: /proc/<PID>/sched is now seqfile based and echoing
>    0 to it clears the maximum-tracking counters.
>
>  - more debugging counters
>
>  - small rounding fix to make the statistical average of rounding errors
>    zero
>
>  - scale both the runtime limit and the granularity on SMP too, and make
>    it dependent on HZ
>
>  - misc cleanups
>
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome,
>
> 	Ingo
> -
Hi
Been testing this version of CFS from last an hour or so and still facing same 
lag problems while browsing sites with heavy JS and or flash usage. Mouse 
movement is pathetic and audio starts to skip. I haven't face this behavior 
with CFS till v11.

Regards
Ananitya

