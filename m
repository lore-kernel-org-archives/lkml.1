Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbZCPRU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbZCPRU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZCPRUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:20:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbZCPRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:20:49 -0400
Date: Mon, 16 Mar 2009 13:20:41 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, travis@sgi.com
Subject: Re: [PULL] cpumask updates for parisc
Message-ID: <20090316172041.GC4282@bombadil.infradead.org>
References: <200903161444.36219.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903161444.36219.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 02:44:35PM +1030, Rusty Russell wrote:
> The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
>   Kyle McMartin (1):
>         parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-parisc.git master
> 
> Rusty Russell (3):
>       cpumask: arch_send_call_function_ipi_mask: parisc
>       cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: parisc
>       cpumask: Use accessors code.: parisc
> 
>  arch/parisc/include/asm/smp.h  |    3 ++-
>  arch/parisc/kernel/irq.c       |    4 ++--
>  arch/parisc/kernel/processor.c |    6 +++---
>  arch/parisc/kernel/smp.c       |   18 +++++++++---------
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 

I've pulled these into a test branch, and will let you know if my
autobuilder shakes out any issues with them.

cheers, Kyle
