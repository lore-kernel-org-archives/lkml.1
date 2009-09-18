Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZIRSMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZIRSMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbZIRSMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:12:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:38695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617AbZIRSMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:12:32 -0400
Subject: Re: [PATCH 1/2]: mm: Make vmalloc_user() align base kernel virtual
 address to SHMLBA.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090918105240.13d74dab.akpm@linux-foundation.org>
References: <20090908.051046.141535022.davem@davemloft.net>
	 <20090918121709.GB19165@elte.hu>
	 <20090918105240.13d74dab.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 20:12:19 +0200
Message-Id: <1253297539.10538.46.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 10:52 -0700, Andrew Morton wrote:
> On Fri, 18 Sep 2009 14:17:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ( Andrew, this patch has mm/* effects - any objections? Would still like
> >   to get this into v2.6.32. )
> 
> I queued this a week ago, along with
> perf-allocate-mmap-buffer-using-vmalloc_user.patch.
> 
> If the latter gets quitably acked I can merge it, otherwise I'll spray
> it at you guys.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>



