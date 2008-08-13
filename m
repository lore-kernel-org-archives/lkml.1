Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYHMMuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYHMMuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYHMMuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:50:12 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:17393 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYHMMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:50:11 -0400
X-BigFish: VPS-29(zz1418M1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K5JIBC-04-00X-01
Date: Wed, 13 Aug 2008 14:49:00 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 2/7] x86: add free_coherent dma_ops callback to GART driver
Message-ID: <20080813124900.GI14993@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com> <1218554657-16070-3-git-send-email-joerg.roedel@amd.com> <20080813093935G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080813093935G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 13 Aug 2008 12:49:00.0641 (UTC) FILETIME=[F55F9510:01C8FD42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 09:45:53AM +0900, FUJITA Tomonori wrote:
> On Tue, 12 Aug 2008 17:24:12 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > index 55cc388..18db09b 100644
> > --- a/arch/x86/kernel/pci-gart_64.c
> > +++ b/arch/x86/kernel/pci-gart_64.c
> 
> It would be better to foil this to the first patch, I think. Any
> reasonable reason to add alloc_coherent and free_coherent with two
> separate patches?

Yes possible. Its always a bit hard to split the patches correctly. Some
maintainers prefer small patches and for others its split up too much
then. If I am in doubt I often chose to split a patch.

> I think that you can remove map_simple in gart (and please don't
> forget to remove map_simple in struct dma_mapping_ops. I think only
> GART uses that hook).

Ok, I will check that and send a sperate patch.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

