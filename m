Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYKUQtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYKUQtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756688AbYKUQtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:49:35 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:10318 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbYKUQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:49:34 -0500
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KAP028-04-Z8P-01
Date: Fri, 21 Nov 2008 17:49:23 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 02/10] x86: add data structures for DMA-API debugging
Message-ID: <20081121164923.GC1386@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-3-git-send-email-joerg.roedel@amd.com> <20081121164254.GC733@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081121164254.GC733@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Nov 2008 16:49:23.0969 (UTC) FILETIME=[1BA7C710:01C94BF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 05:42:54PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +#ifndef __ASM_X86_DMA_DEBUG
> > +#define __ASM_X86_DMA_DEBUG
> > +
> > +/* Allocation flags */
> > +#define DMA_DEBUG_SINGLE        0
> > +#define DMA_DEBUG_SG            1
> > +#define DMA_DEBUG_COHERENT      2
> 
> please use enum for such internal flags, not define.
> 
> > +
> > +struct device;
> > +struct list_head;
> > +
> > +struct dma_debug_entry {
> > +	struct list_head list;
> > +	struct device *dev;
> > +	int type;
> > +	void *cpu_addr;
> > +	u64 dev_addr;
> > +	u64 size;
> > +	int direction;
> > +};
> 
> please align new x86/include structures vertically like this:
> 
> > +struct dma_debug_entry {
> > +	struct list_head	list;
> > +	struct device		*dev;
> > +	int			type;
> > +	void			*cpu_addr;
> > +	u64			dev_addr;
> > +	u64			size;
> > +	int			direction;
> > +};
> 
> [ for the arts major students reading lkml ;-) ]

Ok, I will update the patch :)

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

