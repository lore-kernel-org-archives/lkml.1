Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbZHEGpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbZHEGpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbZHEGpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:45:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856AbZHEGpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:45:10 -0400
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dave Airlie <airlied@gmail.com>, Keir Fraser <kier.fraser@eu.citrix.com>,
       xen-devel@lists.xensource.com, Joerg Roedel <joerg.roedel@amd.com>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Zhenyu Wang <zhenyu.z.wang@intel.com>
In-Reply-To: <4A78C9C6.6010103@goop.org>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
	 <1248851712.19733.214.camel@macbook.infradead.org>
	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
	 <1248860205.19733.238.camel@macbook.infradead.org>
	 <4A78C9C6.6010103@goop.org>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 07:44:56 +0100
Message-Id: <1249454696.9324.325.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 16:52 -0700, Jeremy Fitzhardinge wrote:
> And just when I have patches to use them for their original purpose...
> 
> Looking back over the thread, are you saying that most users are already
> using the DMA API correctly for AGP accesses?  If that's true then we
> should be just fine.

No, not 'most users'. But perhaps we should.

All we've done so far is make intel-agp use the DMA API correctly. And
that's conditional on CONFIG_DMAR. But we could make it unconditional,
and make the other drivers do it too. The code is all fairly generic.

Without an IOMMU, the overhead would be fairly minimal.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

