Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYIVQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYIVQvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYIVQva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:51:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:49208 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbYIVQv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:51:29 -0400
Date: Tue, 23 Sep 2008 01:51:05 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080922162314.GC24392@amd.com>
References: <20080922111730.GF5987@elte.hu>
	<20080923002516R.fujita.tomonori@lab.ntt.co.jp>
	<20080922162314.GC24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080923015059M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 18:23:14 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Sep 23, 2008 at 12:25:24AM +0900, FUJITA Tomonori wrote:
> > 
> > I'm not sure we can because he has a quite different opinion on this,
> > he thinks that the IOMMU parameters are unimportant and minor issue.
> > 
> 
> Stop your personal attacks and come down. I've never said that iommu
> parameters are unimportant. The _move_ of the iommu=[no]fullflush to
> generic code is a minor issue in my opinion. For the user it changes
> nothing. There was an iommu=fullflush parameter before and now there is
> also an iommu=fullflush parameter. The only difference is that it now
> affects AMD IOMMU too.

I have no intention to attack you. I just described what you did.

You moved two IOMMU parameters to generic code, they interact with all
other IOMMUs specific parameters.

If you add parameters to AMD IOMMU, they interact with only AMD IOMMU.

That's a huge difference. You might think that the two parameters are
minor but it would turn out that they are not. What we know now is
that the changes you make affect all the IOMMUs. It's not a minor
issue.


> > I'm against adding new generic IOMMU parameters without serious
> > consideration. Joerg thinks that we can clean up the parameters like
> > adding some for 2.6.28, then add some for 2.6.X, then rename some, in
> > an ad-hoc way.
> 
> Again. Stop your personal attacks.

You added new generic fullflush and nofullflush parameters and
suggested to remove nofullflush parameter without discussing any plan
about further IOMMU parameter changes. We don't even start to discuss
a plan to how to clean up the IOMMU parameters.

I just described what you did.


The patch that I sent doesn't make any changes for you. GART works as
before and AMD IOMMU takes a new parameter, fullflush, as you want. It
does the exact same thing that the first version of your patchset for
2.6.28.

So please let me apply it then we can stop this discussion.
