Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYG2Afo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYG2Afo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYG2Aff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:35:35 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55789 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYG2Aff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:35:35 -0400
Date: Tue, 29 Jul 2008 10:35:33 +1000
From: Simon Horman <horms@verge.net.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
Message-ID: <20080729003533.GH10434@verge.net.au>
References: <20080727234529.GM6175@verge.net.au> <20080728015117.GA12055@verge.net.au> <20080728024526.GB3334@verge.net.au> <20080728034007.GA30450@verge.net.au> <20080728124856.GF5515@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728124856.GF5515@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 02:48:56PM +0200, Ingo Molnar wrote:
> 
> * Simon Horman <horms@verge.net.au> wrote:
> 
> > On Mon, Jul 28, 2008 at 12:45:28PM +1000, Simon Horman wrote:
> > > The rfc patch I made to rename is_kdump_kernel to kernel_has_vmcore,
> > > which I appended to my previous post should have looked more like the
> > > following. Although, as I noted in my previous post, its more a starting
> > > point for discussion than a solution to the problem at hand.
> > 
> > Sorry, one more time. I forgot to quilt refresh.
> 
> doesnt apply cleanly to latest -git:
> 
>  Hunk #1 FAILED at 2070.
>  1 out of 1 hunk FAILED -- saving rejects to file arch/ia64/hp/common/sba_iommu.c.rej
> 
> due to a crossing change i guess. Also, i guess this should go via -mm 
> as it touches fs/proc/vmcore.c and include/linux/crash_dump.h. The x86 
> bits look good to me.
> 
>  Acked-by: Ingo Molnar <mingo@elte.hu>

Sorry about the messiness there. Vivek has a different patch
set that renders most of this irrelevant. I'll fix up the
arch/ia64/hp/common/sba_iommu.c portion to match his changes
so that he can include it in his sereis / it can be included
after his series.

-- 
Horms

