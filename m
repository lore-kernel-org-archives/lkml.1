Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYGaGQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYGaGQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYGaGPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:15:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYGaGPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:15:53 -0400
Date: Wed, 30 Jul 2008 23:14:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>, Eric Munson <ebmunson@us.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-Id: <20080730231428.a7bdcfa7.akpm@linux-foundation.org>
In-Reply-To: <200807311604.14349.nickpiggin@yahoo.com.au>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	<20080730172317.GA14138@csn.ul.ie>
	<20080730103407.b110afc2.akpm@linux-foundation.org>
	<200807311604.14349.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 16:04:14 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Do we expect that this change will be replicated in other
> > memory-intensive apps?  (I do).
> 
> Such as what? It would be nice to see some numbers with some HPC or java
> or DBMS workload using this. Not that I dispute it will help some cases,
> but 10% (or 20% for ppc) I guess is getting toward the best case, short
> of a specifically written TLB thrasher.

I didn't realise the STREAM is using vast amounts of automatic memory. 
I'd assumed that it was using sane amounts of stack, but the stack TLB
slots were getting zapped by all the heap-memory activity.  Oh well.

I guess that effect is still there, but smaller.

I agree that few real-world apps are likely to see gains of this
order.  More benchmarks, please :)
