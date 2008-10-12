Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYJLHjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYJLHjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 03:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYJLHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 03:39:13 -0400
Received: from colo.lackof.org ([198.49.126.79]:34885 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYJLHjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 03:39:11 -0400
Date: Sun, 12 Oct 2008 01:38:59 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081012073859.GE20056@colo.lackof.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <20081010114002D.fujita.tomonori@lab.ntt.co.jp> <200810100848.09557.jbarnes@virtuousgeek.org> <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com> <20081010163350.GF25780@parisc-linux.org> <48EF86E9.8030408@kernel.org> <20081010171214.GG25780@parisc-linux.org> <ada1vyojrme.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada1vyojrme.fsf@cisco.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 10:18:33AM -0700, Roland Dreier wrote:
>  > Open-coding DMA_BIT_MASK() within your driver means that we no longer
>  > have a canonical list of DMA masks in one place.  Instead we have to
>  > grep the entire tree and come up with more-or-less complex scripts to
>  > figure out which bit masks are actually in use.
> 
> Out of curiousity, why do we care about that list?

Originally, I used to track down IO perf issues when porting drivers to ia64.

But knowing the dma masks in use on specific platforms might allow
folks to disable DMA_ZONE (like ia64 since it's always guarateed
either a SWIOTLB or real IOMMU).

Any other uses?

thanks,
grant

> 
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
