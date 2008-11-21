Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYKUQtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYKUQtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYKUQtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:49:23 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54696 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYKUQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:49:22 -0500
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KAP01G-04-Z7U-01
Date: Fri, 21 Nov 2008 17:48:55 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 01/10] x86: add Kconfig entry for DMA-API debugging
Message-ID: <20081121164855.GB1386@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-2-git-send-email-joerg.roedel@amd.com> <20081121164014.GB733@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081121164014.GB733@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Nov 2008 16:48:55.0687 (UTC) FILETIME=[0ACC4970:01C94BF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 05:40:14PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +config DMA_API_DEBUG
> > +	default n
> 
> 'default n' can be omitted in general from interactive Kconfig 
> entries.

Ok, then I remove it.

> 
> > +	bool "Enable debugging of DMA-API usage"
> > +	depends on X86
> 
> perhaps add a proper dependency on iommu or swiotlb presence as well - 
> in case we decide to make it all disable-able again and dont have the 
> callbacks present?

No problem. But its hard to believe that we make the DMA-API
disable-able some day ;)
The best dependency in this case should be SWIOTLB I think.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

