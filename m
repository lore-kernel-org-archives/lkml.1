Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbZHEHJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbZHEHJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933619AbZHEHJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:09:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515AbZHEHJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:09:01 -0400
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <kier.fraser@eu.citrix.com>, xen-devel@lists.xensource.com,
       Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>
In-Reply-To: <21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
	 <1248851712.19733.214.camel@macbook.infradead.org>
	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
	 <1248860205.19733.238.camel@macbook.infradead.org>
	 <4A78C9C6.6010103@goop.org>
	 <1249454696.9324.325.camel@macbook.infradead.org>
	 <21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 08:08:51 +0100
Message-Id: <1249456131.9324.332.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 16:57 +1000, Dave Airlie wrote:
> On Wed, Aug 5, 2009 at 4:44 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> > On Tue, 2009-08-04 at 16:52 -0700, Jeremy Fitzhardinge wrote:
> >> And just when I have patches to use them for their original purpose...
> >>
> >> Looking back over the thread, are you saying that most users are already
> >> using the DMA API correctly for AGP accesses?  If that's true then we
> >> should be just fine.
> >
> > No, not 'most users'. But perhaps we should.
> >
> > All we've done so far is make intel-agp use the DMA API correctly. And
> > that's conditional on CONFIG_DMAR. But we could make it unconditional,
> > and make the other drivers do it too. The code is all fairly generic.
> >
> > Without an IOMMU, the overhead would be fairly minimal.
> >
> 
> I'm not sure how prevalent Xen is on AGP systems, I'm going to guess
> not enough that anyone cares. Intel integrated chips are the only AGP
> codebase user that are made any more, and they don't really use AGP
> its just a legacy of the previous designs.

On the other hand, extending the existing code so that it uses the DMA
API correctly _unconditionally_ rather than only for the Intel driver
would be fairly simple and should be harmless...

-- 
dwmw2

