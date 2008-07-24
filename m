Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbYGXOzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbYGXOzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYGXOzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:55:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:55286 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442AbYGXOzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:55:08 -0400
Date: Thu, 24 Jul 2008 23:40:30 +0900
To: prarit@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4888925E.8050504@redhat.com>
References: <20080724123755.GP31439@8bytes.org>
	<20080724223309C.fujita.tomonori@lab.ntt.co.jp>
	<4888925E.8050504@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080724234111I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 10:31:58 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> 
> >> But I think Prarit is right with this change. If the interface defines
> >> this behavior the IOMMU drivers have to implement it. I am just
> >> wondering that the problem never showed up before. The GART driver is a
> >> few years old now.
> >>     
> >
> > Yeah, I'm not against fixing IOMMUs to make alloc_consistent return
> > the reqeuested size aligned memory. My point is that it's not likely
> > to fix anything. Even with the patch, we hit the above problem because
> > as I explained, the root cause of the problem is the boundary issue;
> > we need to fix pci-dma.c
> >
> >   
> 
> Sorry, I misquoted code up there and was looking for a clear example of 
> where this would happen.  The issue I'm trying to resolve didn't happen 
> on the skge -- it was just a convenient piece of code to examine and 
> point out ;)

So please tell us what driver you hit the bug with. Can you give us
the details?

Thanks,
