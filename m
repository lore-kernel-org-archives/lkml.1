Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXDWETh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXDWETh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 00:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030782AbXDWETh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 00:19:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030776AbXDWETg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 00:19:36 -0400
Message-ID: <462C35FC.3050109@redhat.com>
Date: Mon, 23 Apr 2007 00:28:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au>
In-Reply-To: <462ACA40.8070407@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> So where is the down_write coming from in this workload, I wonder?
> Heap management? What syscalls?

Trying to answer this question, I straced the mysql threads that
showed up in top when running a single threaded sysbench workload.

There were no mmap, munmap, brk, mprotect or madvise system calls
in the trace.

MySQL has me puzzled, but it seems to have some other people
interested too.

I think I'll go play a bit with ebizzy now, to see how other
workloads are affected by our kernel changes.
