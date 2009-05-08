Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbZEHJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbZEHJfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZEHJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:35:28 -0400
Received: from 8bytes.org ([88.198.83.132]:44518 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbZEHJf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:35:27 -0400
Date: Fri, 8 May 2009 11:35:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, airlied@linux.ie, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: IOMMU and graphics cards
Message-ID: <20090508093526.GB13708@8bytes.org>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp> <20090507100114.GF4059@amd.com> <1241691721.3531.73.camel@macbook.infradead.org> <20090507.113632.210373283.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507.113632.210373283.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 11:36:32AM -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Thu, 07 May 2009 11:22:01 +0100
> 
> > On Thu, 2009-05-07 at 12:01 +0200, Joerg Roedel wrote:
> >> > Looks like the DRM code uses the DMA API.
> >> 
> >> The proprietary drivers make problems so far. For the ATI one I am in
> >> contact with the developers to try to fix it. But I can't do anything
> >> about the other proprietary driver I am aware of :-(
> > 
> > I see no harm in "breaking" code which was already broken. If that's the
> > only reason we're enabling the graphics workaround, let's turn it off.
> 
> Seriously, this is an enormous price to pay just for one bad apple
> proprietary driver.
> 
> I can't believe the level of concessions some people are suggesting.

This concession is already in the VT-d code. And this concession is
_enabled_ in enterprise distribtions supporting VT-d. I don't like the
way it is implemented there and I definitly will not implement a similar
way for the AMD IOMMU. What I try to achieve is a consistent solution
for both IOMMUs. Having the broken drivers work on VT-d but not on
AMD IOMMU is clearly a bad solution.

The other way to achieve consistency is to remove the workaround from
VT-d code which significantly increases the chance to get the broken
stuff fixed. David?

> Let's not make IOMMU's basically useless by working around one broken
> driver.

Agreed.

> Proper interfaces for what this driver is trying to do have existed in
> the kernel for 10+ years.  There are no excuses, and it's time for
> Nvidia to get with the game plan.

Agreed.

Joerg

