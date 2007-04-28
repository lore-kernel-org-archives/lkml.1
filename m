Return-Path: <linux-kernel-owner+w=401wt.eu-S1031183AbXD1PUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031183AbXD1PUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031188AbXD1PUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:20:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36986 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031183AbXD1PUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:20:49 -0400
Date: Sat, 28 Apr 2007 20:58:02 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070428152802.GA10179@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070425214704.GA32572@elte.hu> <20070428124516.GA27292@in.ibm.com> <20070428135338.GA8207@elte.hu> <20070428152327.GE14716@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428152327.GE14716@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 08:53:27PM +0530, Srivatsa Vaddagiri wrote:
> With the patch below applied, I ran a "time -p make -s -j10 bzImage"
> test.

On a 4CPU (accounting HT) Intel Xeon 3.6GHz box

> 
> 2.6.20 + cfs-v6			-> 186.45 (real)
> 2.6.20 + cfs-v6 + this_patch	-> 184.55 (real)
> 
> or about ~1% improvement in real wall-clock time. This was with the default 
> sched_granularity_ns of 6000000. I suspect larger the value of
> sched_granularity_ns and the number of (SCHED_NORMAL) tasks in system, better 
> the benefit from this caching.

-- 
Regards,
vatsa
