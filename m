Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYKTE0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYKTE0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 23:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYKTEZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 23:25:46 -0500
Received: from sh.osrg.net ([192.16.179.4]:34200 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYKTEZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 23:25:45 -0500
Date: Thu, 20 Nov 2008 13:25:18 +0900
To: muli@il.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081119125748.GK7113@il.ibm.com>
References: <20081118154322.GX13394@amd.com>
	<20081119150504G.fujita.tomonori@lab.ntt.co.jp>
	<20081119125748.GK7113@il.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081120132545Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 14:57:50 +0200
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> > device isolation is not free; e.g. use more memory rather than
> > sharing a protection domain. I guess that more people prefer sharing
> > a protection domain by default.
> 
> I doubt it, why use an isolation-capable IOMMU at all if not for the
> increased reliability? The majority of modern devices---those that you
> are likely to find on machines with an IOMMU---don't have DMA
> limitations.

I guess that there are still some modern SATA HBAs that are not
capable of 64bit DMA. You might be right though.


> > It had been the default option for AMD IOMMU until you hit the
> > bugs. IIRC, VT-d also shares a protection domain by default. It
> > would be nice to avoid surprising users if the two virtualization
> > IOMMUs works in the similar way.
> 
> Calgary has a per-bus protection domain, both on x86 and PPC.

I see. Then it might be better to change VT-d to use a separate
protection domain by default.
