Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZG2Jgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZG2Jgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZG2Jgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:36:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZG2Jgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:36:52 -0400
Subject: Re: [RFC] Make AGP work with IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Dave Airlie <airlied@gmail.com>, Keir Fraser <kier.fraser@eu.citrix.com>,
       xen-devel@lists.xensource.com
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
In-Reply-To: <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
	 <1248851712.19733.214.camel@macbook.infradead.org>
	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 10:36:45 +0100
Message-Id: <1248860205.19733.238.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 18:43 +1000, Dave Airlie wrote:
> >> don't suppose we want page_to_gart or is the double function nicer?
> >
> > I pondered that briefly. But then observed that phys_to_gart() and
> > gart_to_phys() _always_ describe an identity mapping, so perhaps they
> > could just be ditched completely?
> 
> Yeah that could work too, no idea why they were introduced, well before my time.

http://git.infradead.org/users/dwmw2/iommu-agp.git?a=commitdiff;h=8bf2f3a9

It was introduced by Keir in 2005 for Xen (commit 07eee78e). I suspect
it can die though, and that the right answer there is also to use the
DMA API correctly.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

