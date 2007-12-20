Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbXLTVW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbXLTVW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbXLTVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:22:35 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:44331 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254AbXLTVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:22:34 -0500
Message-ID: <476ADD05.5090801@opengridcomputing.com>
Date: Thu, 20 Dec 2007 15:22:13 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: benh@au1.ibm.com
CC: Roland Dreier <rdreier@cisco.com>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Wen Xiong <wenxiong@us.ibm.com>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <pmac@au1.ibm.com>
Subject: Re: [ofa-general] iommu dma mapping alignment requirements
References: <476AA2E2.5010007@opengridcomputing.com>	 <adalk7pz1ck.fsf@cisco.com> <476ABE60.9030805@opengridcomputing.com>	 <476AC2A5.8060200@opengridcomputing.com> <1198182061.6779.7.camel@pasglop>
In-Reply-To: <1198182061.6779.7.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2007-12-20 at 13:29 -0600, Steve Wise wrote:
> 
>> Or based on the alignment of vaddr actually...
> 
> The later wouldn't be realistic. What I think might be necessay, though
> it would definitely cause us problems with running out of iommu space
> (which is the reason we did the switch down to 4K), is to provide
> alignment to the real page size, and alignement to the allocation order
> for dma_map_consistent.
> 
> It might be possible to -tweak- and only provide alignment to the page
> size for allocations that are larger than IOMMU_PAGE_SIZE. That would
> solve the problem with small network packets eating up too much iommu
> space though.
> 
> What do you think ?

That might work.

If you gimme a patch, i'll try it out!

Steve.
