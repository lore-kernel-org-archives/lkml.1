Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXDVBxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXDVBxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 21:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXDVBxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 21:53:43 -0400
Received: from mail30.syd.optusnet.com.au ([211.29.133.193]:50459 "EHLO
	mail30.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955AbXDVBxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 21:53:42 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>, ck list <ck@vds.kolivas.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Sun, 22 Apr 2007 11:51:37 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
In-Reply-To: <20070421121235.GA2044@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221151.38464.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 22:12, Willy Tarreau wrote:
> 2) SD-0.44
>
>    Feels good, but becomes jerky at moderately high loads. I've started
>    64 ocbench with a 250 ms busy loop and 750 ms sleep time. The system
>    always responds correctly but under X, mouse jumps quite a bit and
>    typing in xterm or even text console feels slightly jerky. The CPU is
>    not completely used, and the load varies a lot (see below). However,
>    the load is shared equally between all 64 ocbench, and they do not
>    deviate even after 4000 iterations. X uses less than 1% CPU during
>    those tests.

Found it. I broke SMP balancing again so there is serious scope for 
improvement on SMP hardware. That explains the huge load variations. Expect 
yet another fix soon, which should improve behaviour further :)

-- 
-ck
