Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZIRRxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZIRRxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbZIRRxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:53:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757369AbZIRRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:52:59 -0400
Date: Fri, 18 Sep 2009 10:52:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2]: mm: Make vmalloc_user() align base kernel virtual
 address to SHMLBA.
Message-Id: <20090918105240.13d74dab.akpm@linux-foundation.org>
In-Reply-To: <20090918121709.GB19165@elte.hu>
References: <20090908.051046.141535022.davem@davemloft.net>
	<20090918121709.GB19165@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 14:17:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> ( Andrew, this patch has mm/* effects - any objections? Would still like
>   to get this into v2.6.32. )

I queued this a week ago, along with
perf-allocate-mmap-buffer-using-vmalloc_user.patch.

If the latter gets quitably acked I can merge it, otherwise I'll spray
it at you guys.

Merging
mm-make-vmalloc_user-align-base-kernel-virtual-address-to-shmlba.patch
via another tree will cause a teeny reject at my end, not a problem.
