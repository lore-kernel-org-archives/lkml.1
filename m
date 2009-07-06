Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZGFVgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZGFVgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZGFVf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:35:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36758 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZGFVf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:35:57 -0400
Date: Mon, 6 Jul 2009 22:35:59 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: David Woodhouse <dwmw2@infradead.org>
cc: Joerg Roedel <joerg.roedel@amd.com>, Joerg Roedel <joro@8bytes.org>,
       Zhenyu Wang <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com, David Miller <davem@davemloft.net>, eric@anholt.net
Subject: Re: IOMMU and graphics cards
In-Reply-To: <1246889932.2615.81.camel@macbook.infradead.org>
Message-ID: <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>  <20090507100114.GF4059@amd.com>  <1241691721.3531.73.camel@macbook.infradead.org>  <20090507.113632.210373283.davem@davemloft.net>  <20090508093526.GB13708@8bytes.org>  <1246883177.2615.33.camel@macbook.infradead.org>
  <20090706131156.GL5380@amd.com> <1246889932.2615.81.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Jul 2009, David Woodhouse wrote:

> On Mon, 2009-07-06 at 15:11 +0200, Joerg Roedel wrote:
> > Ok, cool, that sounds good. Which in-kernel DRM drivers break with IOMMU
> > for you? I'll may probably add a similar temporary workaround for AMD
> > IOMMU too...
> 
> The Intel one definitely broke -- I don't know about the others. There
> are some old patches at http://people.freedesktop.org/~zhen/agp-mm-*
> which make it look like _all_ AGP drivers are broken.
> 
> I wouldn't bother adding the workaround -- as I said, I'm planning to
> rip it out of 2.6.32 (and in linux-next as soon as it's reasonable to do
> so). Let's just let them fix it.

cc'ing Eric,

My memory of this is graphics becomes totally useless and can be 10x-50x 
slower. I think ripping this out without the person doing the ripping 
taking responsiblity for doing speed regression testing is totally insane.

I personally have no IOMMU hw from Intel or AMD and nobody has seen it fit 
to supply me with any at any point in time, I'm not on the correct gravy 
train. So I suspect the people with the hw will have to do the work and 
the regression testing.

Dave.
