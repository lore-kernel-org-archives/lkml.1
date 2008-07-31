Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYGaKMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYGaKMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYGaKMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:12:30 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:63429 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYGaKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:12:29 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4V8C6-04-OFK-01
Date: Thu, 31 Jul 2008 12:12:07 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Muli Ben-Yehuda <muli@il.ibm.com>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 calgary: replace num_dma_pages() with iommu_num_pages()
Message-ID: <20080731101207.GS4851@amd.com>
References: <1217248100-3019-1-git-send-email-joerg.roedel@amd.com> <20080728170904.GA10532@il.ibm.com> <20080731100103.GA488@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080731100103.GA488@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 31 Jul 2008 10:12:07.0294 (UTC) FILETIME=[E33611E0:01C8F2F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:01:03PM +0200, Ingo Molnar wrote:
> * Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> 
> > On Mon, Jul 28, 2008 at 02:28:20PM +0200, Joerg Roedel wrote:
> > > This patch removes the num_dma_pages() function from Calgary IOMMU code and
> > > replaces it with the generic iommu_num_pages() function.
> > > 
> > > Cc: Muli Ben-Yehuda <muli@il.ibm.com>
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > Thanks Joerg,
> > 
> > Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> applied to tip/x86/iommu - thanks.

Ingo,

can you drop this patch please? It was already picked up by Andrew and
he has sent it to you. I already sent a drop message as a reply to the
patch Andrew has sent to you. I am currently working on a patch series
to make the iommu_num_pages function generic and this series will
include a new version of this patch.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

