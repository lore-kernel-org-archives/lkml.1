Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYIRHcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYIRHcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYIRHcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:32:46 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:61610 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYIRHcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:32:45 -0400
X-BigFish: VPS-39(zz1418M1432R98dR1805M179dR936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7DRM9-04-JZU-01
Date: Thu, 18 Sep 2008 09:32:32 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 18/23] AMD IOMMU: simplify dma_mask_to_pages
Message-ID: <20080918073232.GB24392@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com> <1221670377-19295-19-git-send-email-joerg.roedel@amd.com> <20080918041717S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080918041717S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 18 Sep 2008 07:32:32.0165 (UTC) FILETIME=[B63B1550:01C91960]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 04:20:20AM +0900, FUJITA Tomonori wrote:
> On Wed, 17 Sep 2008 18:52:52 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > The current calculation is very complicated. This patch replaces it with
> > a much simpler version.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> I think that you can use iommu_device_max_index() for what
> dma_mask_to_pages does.

Hmm, in theory yes. But iommu_device_max_index() returns a size in bytes
and not in pages. So I still need to do the page shift somewhere. This
eliminates somewhat the benefit in this particular case.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

