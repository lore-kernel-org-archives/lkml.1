Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbXKPFK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbXKPFK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 00:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXKPFKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 00:10:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43805 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXKPFKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 00:10:48 -0500
Date: Fri, 16 Nov 2007 14:09:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org,
       kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH][2.6.24-rc2-mm1] memory hotplug x86_64 fix [3/3] fix
 section mismatch in init_memory_mapping
Message-Id: <20071116140905.6ac8746c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115165935.b71dab7a.akpm@linux-foundation.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
	<20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193016.daabe91e.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115193639.7c170e57.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115165935.b71dab7a.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 16:59:35 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Index: linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
> > ===================================================================
> > --- linux-2.6.24-rc2-mm1.orig/arch/x86/mm/init_64.c
> > +++ linux-2.6.24-rc2-mm1/arch/x86/mm/init_64.c
> > @@ -347,7 +347,7 @@ static void __init find_early_table_spac
> >  /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
> >     This runs before bootmem is initialized and gets pages directly from the 
> >     physical memory. To access them they are temporarily mapped. */
> > -void __meminit init_memory_mapping(unsigned long start, unsigned long end)
> > +void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
> >  { 
> >  	unsigned long next; 
> >  
> 
> again, I _think_ this fixes a bug in mainline.  Can you check that please?
> 
Yes, this section mismatch happens on 2.6.24-rc2.

Thanks,
-Kame

