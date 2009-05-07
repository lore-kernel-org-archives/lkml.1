Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZEGLQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZEGLQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZEGLQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:16:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:53706 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbZEGLQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:16:26 -0400
Date: Thu, 7 May 2009 20:14:48 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, airlied@linux.ie,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, dwmw2@infradead.org
Subject: Re: IOMMU and graphics cards
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090507110135.GC28398@elte.hu>
References: <20090507100114.GF4059@amd.com>
	<20090507191724N.fujita.tomonori@lab.ntt.co.jp>
	<20090507110135.GC28398@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090507201538U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 20:14:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 13:01:35 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > The proprietary drivers make problems so far. For the ATI one I 
> > > am in contact with the developers to try to fix it. But I can't 
> > > do anything about the other proprietary driver I am aware of :-(
> > 
> > I don't know anything about the graphic drivers but are there any 
> > other proprietary drivers except for ATI and AMD? Fixing only two 
> > drivers to make the majority happy?
> 
> ATI ~== AMD these days. The problem is Nvidia cards stuck into AMD 
> systems.

Oops, I meant ATI and Nvidia.


> I guess refusing those DMA accesses (and printing something 
> meaningful and relentlessly honest so that the user knows where the 
> problem comes from) is the proper solution.

Refusing DMA means that we will break these broken drivers. That's
what David and I like. Yeah, telling users explicitly who is to blame
for the problem is even better.

> There will be some 
> end-user moaning, there might be distros turning off the IOMMU code 
> summarily, but nvidia-in-AMD-box is an unfriendly alliance to begin 
> with.
