Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbYDCR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbYDCR7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYDCR7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:59:05 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:53056 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYDCR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:59:03 -0400
Date: Thu, 3 Apr 2008 19:58:56 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, geert@linux-m68k.org, ralf@linux-mips.org,
       kyle@parisc-linux.org, paulus@samba.org, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 17/22] s390: Use generic show_mem()
Message-ID: <20080403175856.GA4131@osiris.boeblingen.de.ibm.com>
References: <12071688283927-git-send-email-hannes@saeurebad.de> <12071690203023-git-send-email-hannes@saeurebad.de> <20080403075029.GB4125@osiris.boeblingen.de.ibm.com> <87iqyzozyx.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqyzozyx.fsf@saeurebad.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 03:00:22PM +0200, Johannes Weiner wrote:
> Hi,
> 
> Heiko Carstens <heiko.carstens@de.ibm.com> writes:
> 
> >> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> >> index 8053245..27b94cb 100644
> >> --- a/arch/s390/mm/init.c
> >> +++ b/arch/s390/mm/init.c
> >> @@ -42,42 +42,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
> >>  pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__((__aligned__(PAGE_SIZE)));
> >>  char  empty_zero_page[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> >> 
> >> -	printk("Free swap:       %6ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
> >> -	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
> >> -	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
> >> -	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
> >> -	printk("%lu pages slab\n",
> >> -	       global_page_state(NR_SLAB_RECLAIMABLE) +
> >> -	       global_page_state(NR_SLAB_UNRECLAIMABLE));
> >> -	printk("%lu pages pagetables\n", global_page_state(NR_PAGETABLE));
> >
> > These are all missing in the generic implementation.
> 
> These are all duplicates from show_free_areas().

In this case ignore my comment ;)
Btw. your patch regarding the removal of show_free_areas() from
s390's arch code will be merged during the next merge window.
