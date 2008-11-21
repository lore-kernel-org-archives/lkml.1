Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYKUQ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYKUQ5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYKUQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:57:32 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:22265 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYKUQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:57:31 -0500
X-BigFish: VPS-38(zz1432R98dR936eQ1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KAP0FK-03-TVL-01
Date: Fri, 21 Nov 2008 17:57:22 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] DMA-API debugging facility
Message-ID: <20081121165722.GD1386@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227286492.4901.208.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1227286492.4901.208.camel@macbook.infradead.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Nov 2008 16:57:22.0713 (UTC) FILETIME=[39025090:01C94BFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 04:54:52PM +0000, David Woodhouse wrote:
> On Fri, 2008-11-21 at 17:26 +0100, Joerg Roedel wrote:
> > this patchset introduces code to debug drivers usage of the DMA-API.
> > Tests with hardware IOMMUs have shown several bugs in drivers
> > regarding the usage of that API.
> > Problems were found especially in network card drivers.
> 
> This is really useful -- but surely it shouldn't be x86-specific?
> 
> All the code except the hooks in the architecture's dma_map_single() et
> al functions could be generic, couldn't it?

Yes, in principle we could move most of it to generic code. There is
nothing architecture specific in it.
Anybody who prefers this to be arch/x86 before moving it to lib/?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

