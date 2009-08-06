Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZHFTgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZHFTgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbZHFTga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:36:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbZHFTga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:36:30 -0400
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dave Airlie <airlied@gmail.com>, xen-devel@lists.xensource.com,
       Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org,
       Keir Fraser <kier.fraser@eu.citrix.com>
In-Reply-To: <4A7B2FC6.9070104@goop.org>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
	 <1248851712.19733.214.camel@macbook.infradead.org>
	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
	 <1248860205.19733.238.camel@macbook.infradead.org>
	 <4A78C9C6.6010103@goop.org>
	 <1249454696.9324.325.camel@macbook.infradead.org>
	 <21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>
	 <4A79CEEC.9030008@goop.org>
	 <21d7e9970908051612v140c2ebfu591e8fe817237889@mail.gmail.com>
	 <4A7B2FC6.9070104@goop.org>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 20:36:21 +0100
Message-Id: <1249587381.568.58.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 12:32 -0700, Jeremy Fitzhardinge wrote:
> On 08/05/09 16:12, Dave Airlie wrote:
> > My main problem with doing this is getting testing coverage on older
> > systems, if we change all the AGP drivers, the time to find we busted
> > something is probably not until the next major distro release with this code
> > in it. So people can run stuff on 5 year old hardware in 6 months? I'm
> > not sure the gains justify the costs, but if you guys really want to do it
> > I'll take the patch, just be prepared to have it ripped out the minute
> > we get a regression we can't figure out because we haven't got the hw anymore.
> >   
> 
> Can you point to some changesets/patches to act as an example/template
> for the changes needed?

http://git.infradead.org/users/dwmw2/iommu-agp.git/shortlog/ba3139f2577eee24479db73b8dfc7d78eaf4c486

Some of the code added to intel-agp should probably be generic.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

