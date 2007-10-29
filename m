Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbXJ2VVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbXJ2VVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXJ2VVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:21:25 -0400
Received: from smtp.aaisp.net.uk ([81.187.81.52]:47674 "EHLO smtp.aaisp.net.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbXJ2VVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:21:24 -0400
X-Greylist: delayed 3215 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 17:21:24 EDT
Subject: Re: 2.6.23 boot failures on x86-64.
From: Martin Ebourne <martin@zepler.org>
To: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071029194311.GE1650@redhat.com>
References: <20071029175014.GH7793@redhat.com>
	 <200710291918.43869.ak@suse.de> <20071029184747.GB1650@redhat.com>
	 <200710292003.09317.ak@suse.de>  <20071029194311.GE1650@redhat.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 21:21:02 +0000
Message-Id: <1193692862.3133.14.camel@avenin.ebourne.me.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 15:43 -0400, Dave Jones wrote:
> On Mon, Oct 29, 2007 at 08:03:09PM +0100, Andi Kleen wrote:
>  > >  > But if allocating bootmem >4G doesn't work on these systems
>  > >  > most likely they have more problems anyways. It might be better
>  > >  > to find out what goes wrong exactly.
>  > > Any ideas on what to instrument ?
>  > 
>  > See what address the bootmem_alloc_high returns; check if it overlaps
>  > with something etc.
>  > 
>  > Fill the memory on the system and see if it can access all of its memory.
> 
> Martin, as you have one of the affected systems, do you feel up to this?

Faking a node at 0000000000000000-000000001fff0000
Bootmem setup node 0 0000000000000000-000000001fff0000
sparse_early_mem_map_alloc: returned address ffff81000070b000

My box has 512MB of RAM.

Cheers,

Martin.

