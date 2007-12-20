Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbXLTVCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbXLTVCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXLTVC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:02:27 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:42948 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbXLTVC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:02:27 -0500
Message-ID: <476AD84E.4000507@opengridcomputing.com>
Date: Thu, 20 Dec 2007 15:02:06 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: benh@au1.ibm.com
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>,
       Wen Xiong <wenxiong@us.ibm.com>, Olof Johansson <olof@lixom.net>,
       Paul Mackerras <pmac@au1.ibm.com>
Subject: Re: iommu dma mapping alignment requirements
References: <476AA2E2.5010007@opengridcomputing.com> <1198181862.6779.3.camel@pasglop>
In-Reply-To: <1198181862.6779.3.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Adding A few more people to the discussion. You may well be right and we
> would have to provide the same alignment, though that sucks a bit as one
> of the reason we switched to 4K for the IOMMU is that the iommu space
> available on pSeries is very small and we were running out of it with
> 64K pages and lots of networking activity.
> 

But smarter NIC drivers can resolve this too, I think, but perhaps 
carving up full pages of mapped buffers instead of just assuming mapping 
is free...

perhaps...
