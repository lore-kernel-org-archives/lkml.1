Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbYLOMMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbYLOMMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 07:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYLOMLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:11:50 -0500
Received: from ozlabs.org ([203.10.76.45]:45065 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYLOMLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:11:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18758.18075.30744.666904@cargo.ozlabs.ibm.com>
Date: Mon, 15 Dec 2008 22:59:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <20081214212829.GA9435@elte.hu>
References: <20081214212829.GA9435@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> For example, a full kernel build's statistics on a 16-way x86 box are:
> 
>   $ timec -e -5,-4,-3,1,2,3,5 make -j32 bzImage
> 
>   Performance counter stats for 'make':
> 
>          142420.882  task clock ticks     (millisecs)
> 
>             9951033  pagefaults           (events)
>              302628  context switches     (events)
>               57810  CPU migrations       (events)
>        208439082509  instructions         (events)
>           657918810  cache references     (events)
>           120243697  cache misses         (events)
>          3134162468  branch misses        (events)

Does this machine have sufficient hardware counters to count those
four hardware events at the same time?  Or were those counters
timeshared onto 1 or 2 hardware counters?  If it's the latter, are
those counts from half or a quarter of the total execution?

Paul.
