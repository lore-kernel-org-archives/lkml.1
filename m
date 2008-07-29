Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYG2J7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYG2J7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYG2J7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:59:18 -0400
Received: from sh.osrg.net ([192.16.179.4]:56442 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbYG2J7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:59:17 -0400
Date: Tue, 29 Jul 2008 18:58:08 +0900
To: joerg.roedel@amd.com
Cc: sfr@canb.auug.org.au, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080729095027.GA4851@amd.com>
References: <20080728.222439.176200666.davem@davemloft.net>
	<20080729164523.bfd2d539.sfr@canb.auug.org.au>
	<20080729095027.GA4851@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080729185838W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 11:50:27 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Jul 29, 2008 at 04:45:23PM +1000, Stephen Rothwell wrote:
> > Hi Dave,
> > 
> > On Mon, 28 Jul 2008 22:24:39 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > >
> > > sparc64: Fix build after addition of iommu_num_pages() helper.
> > 
> > I added this to the end of linux-next for today.  Hopefully we will have
> > a fix in Linus' tree tomorrow.
> 
> Yes, my fault, sorry for that breakage :-/
> I think moving that function to x86-only code is the best solution for
> now. Before moving it back to generic code we need an architecture
> independent way to find out the IOMMU page size.

Agreed, it fixes both SPARC and POWER breakages.


> FUJITA,
> 
> do you want to work on that or should I try to do this and send it to
> you for review?

I've already sent a patch that fixes the breakages in such way:

http://marc.info/?l=linux-kernel&m=121730644704448&w=2

