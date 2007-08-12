Return-Path: <linux-kernel-owner+w=401wt.eu-S934668AbXHLLxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668AbXHLLxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbXHLLxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:53:32 -0400
Received: from 1wt.eu ([62.212.114.60]:1672 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758126AbXHLLxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:53:31 -0400
Date: Sun, 12 Aug 2007 13:52:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.16 review 08/28] x86_64: allocate sparsemem memmap above 4G
Message-ID: <20070812115256.GC29161@1wt.eu>
References: <20070811184752.%N@1wt.eu> <20070811184837.%N@1wt.eu> <200708121218.12411.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708121218.12411.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sun, Aug 12, 2007 at 12:18:11PM +0200, Andi Kleen wrote:
> On Saturday 11 August 2007 21:48, Willy Tarreau wrote:
> > On systems with huge amount of physical memory, VFS cache and memory memmap
> > may eat all available system memory under 4G, then the system may fail to
> > allocate swiotlb bounce buffer.
> >
> > There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix dose
> > not cover sparsemem model.
> 
> Have you checked if sparsemem even worked in 2.6.20?

No, unfortunately I'm not equipped for that.

> Irc it was quite
> unstable a couple of releases ago. There were times where it rarely
> booted on x86-64 because so few people test it. 
> If not the patch is not needed, although relatively harmless too.

OK. So I'd propose the following :
 - if someone can confirm that it did not work anyway, I remove the patch
   which becomes useless.
 - but if we get no confirmation, assuming that in doubt, some people _may_
   be relying on it and that it does not affect other ones, we'd keep it.

are you OK with this ?

Thanks,
Willy

