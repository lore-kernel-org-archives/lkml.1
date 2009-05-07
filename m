Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZEGNBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZEGNBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZEGNBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:01:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:53986 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbZEGNBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:01:09 -0400
Date: Thu, 7 May 2009 21:59:19 +0900
To: joerg.roedel@amd.com
Cc: dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090507121535.GH4059@amd.com>
References: <20090507100114.GF4059@amd.com>
	<1241691721.3531.73.camel@macbook.infradead.org>
	<20090507121535.GH4059@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090507215933K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 21:59:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 14:15:35 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, May 07, 2009 at 11:22:01AM +0100, David Woodhouse wrote:
> > On Thu, 2009-05-07 at 12:01 +0200, Joerg Roedel wrote:
> > > > Looks like the DRM code uses the DMA API.
> > > 
> > > The proprietary drivers make problems so far. For the ATI one I am in
> > > contact with the developers to try to fix it. But I can't do anything
> > > about the other proprietary driver I am aware of :-(
> > 
> > I see no harm in "breaking" code which was already broken. If that's the
> > only reason we're enabling the graphics workaround, let's turn it off.
> 
> Well, it is not that simple. Having no workaround at all will not result
> in working proprietary drivers. More likely is that distros just disable
> the IOMMU because their customers want to use these drivers for working
> 3d acceleration.

Have you already discussed this issue with distribution people?

I'm not sure if they would just disable the IOMMU. They want it for
exotic virtualization features?


> As I wrote in the original mail I think we should just make sure that
> these drivers still work with an IOMMU without disabling device
> isolation.
