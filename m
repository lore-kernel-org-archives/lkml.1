Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZCXKMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZCXKMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZCXKMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:12:44 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57605 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbZCXKMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:12:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18888.45586.544707.554429@cargo.ozlabs.ibm.com>
Date: Tue, 24 Mar 2009 21:12:34 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de
Subject: Re: [tip:perfcounters/core] perf_counter tools: remove glib
	dependency and fix bugs in kerneltop.c
In-Reply-To: <20090324093817.GA1772@elte.hu>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
	<tip-6357003d6c8bc0056d79768692955da6d151880f@git.kernel.org>
	<20090324093817.GA1772@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> btw.,:
> 
> | Performance counter stats for 'ls':
> |
> |        1915281  task clock ticks     (events)
> |
> |              6  CPU migrations       (events)
> |              6  CPU migrations       (events)
> |            284  pagefaults           (events)
> |       4.333761  CPU cycles           (msecs)
> |       1.544153  instructions         (msecs)
> |         620030  cache references     (events)
> |          17632  cache misses         (events)
> |
> | Wall-clock time elapsed:     1.868138 msecs
> 
> the 'instructions' field is weird - it should not be millisecs but 
> 'events'.

Is that with my patch applied?  That was one of the things I fixed, or
at least intended to fix :).

Paul.
