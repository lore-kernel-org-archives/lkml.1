Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0CBNtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:49:33 -0500
Received: from sh.osrg.net ([192.16.179.4]:47897 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab0CBNtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:49:31 -0500
Date: Tue, 2 Mar 2010 22:49:20 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201003021438.32144.arnd@arndb.de>
References: <201003021303.26064.arnd@arndb.de>
	<20100302212513N.fujita.tomonori@lab.ntt.co.jp>
	<201003021438.32144.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100302224858G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Mar 2010 22:49:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 14:38:31 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 02 March 2010, FUJITA Tomonori wrote:
> > Yeah, but IIRC, Alpha, x86_64 GART, parisc, and IA64 don't have
> > CONFIG_ option for IOMMU virtual merging. I prefer to avoid to adding
> > something like CONFIG_HAVE_IOMMU_VMERGE for them. If we add
> > CONFIG_HAVE_IOMMU_VMERGE to them, it's a bit strange not to add the
> > feature to disable virtual merging for them (I guess GART already has
> > the feature though).
> 
> While I think the runtime feature (actually a workaround for broken device
> drivers)

What does "broken device drivers" mean here?

> should be consistently used on all architectures, or removed
> entirely, it's orthogonal to this discussion.
