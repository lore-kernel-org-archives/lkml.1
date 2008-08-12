Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYHLQIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYHLQIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYHLQH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:07:56 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56321 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYHLQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:07:55 -0400
Date: Tue, 12 Aug 2008 19:06:58 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org
Subject: Re: [PATCH 0/7] x86 dma_*_coherent rework patchset
Message-ID: <20080812160658.GH30426@il.ibm.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added Andi to CC]

On Tue, Aug 12, 2008 at 05:24:10PM +0200, Joerg Roedel wrote:
> Hi,
> 
> this patchset reworks the dma_*_coherent functions in the DMA layer
> for the x86 architecture. The patch series extends the existing DMA
> backends with missing *coherent callbacks and simplifies the generic
> function to basically only call the registered backend. This allows
> future optimizations in hardware specific IOMMU implementations.
> The code ist tested on AMD64 with AMD IOMMU and GART as well as on
> my old 486 box. It is not yet tested on a Calgary IOMMU system.

Now it is---appears to work fine on a Calgary system.

In general the patchset looks good and is definitely a step in the
right direction. I am a bit concerned about the contortions that the
generic dma_alloc_coherent went through before calling the ops
version---have you verified they are no longer needed?

Cheers,
Muli
-- 
Workshop on I/O Virtualization (WIOV '08)
Co-located with OSDI '08, Dec 2008, San Diego, CA
http://www.usenix.org/wiov08
