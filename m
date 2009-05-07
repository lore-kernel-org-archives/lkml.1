Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZEGKnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZEGKnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZEGKnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:43:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:55293 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZEGKnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:43:40 -0400
Date: Thu, 7 May 2009 19:42:29 +0900
To: dwmw2@infradead.org
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241691721.3531.73.camel@macbook.infradead.org>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	<20090507100114.GF4059@amd.com>
	<1241691721.3531.73.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090507194238G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 19:42:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 May 2009 11:22:01 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2009-05-07 at 12:01 +0200, Joerg Roedel wrote:
> > > Looks like the DRM code uses the DMA API.
> > 
> > The proprietary drivers make problems so far. For the ATI one I am in
> > contact with the developers to try to fix it. But I can't do anything
> > about the other proprietary driver I am aware of :-(
> 
> I see no harm in "breaking" code which was already broken. If that's the
> only reason we're enabling the graphics workaround, let's turn it off.

I also prefer that approach. Adding a workaround for the 'bugs' of the
proprietary drivers doesn't sound a nice idea. Let them to fix the
bugs. It's not difficult at all to convert a driver to use the DMA
API.
