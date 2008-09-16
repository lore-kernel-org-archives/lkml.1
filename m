Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYIPPwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYIPPwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYIPPwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:52:32 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20645 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYIPPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:52:31 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7APEW-03-SJ9-01
Date: Tue, 16 Sep 2008 17:52:11 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: andi@firstfloor.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080916155211.GW24392@amd.com>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <87hc8grjuf.fsf@basil.nowhere.org> <20080916222032O.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080916222032O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 16 Sep 2008 15:52:11.0585 (UTC) FILETIME=[2E880B10:01C91814]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 10:20:40PM +0900, FUJITA Tomonori wrote:
> On Tue, 16 Sep 2008 02:54:32 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> > 
> > > Currently, gart IOMMU ignores device's dma_mask when it does virtual
> > > mappings. So it could give a device a virtual address that the device
> > > can't access to.
> > 
> > Huh? That is what the need_iommu() logic in gart_map_sg()
> > does. An I'm not aware of any bugs in this area.
> 
> What the need_iommu() does is seeing if GART needs to do virtual
> mappings or not.
> 
> (After need_iommu() checking) What this patchset does is to guarantee
> that GART provides a virtual address that a device can access to.
> 
> 
> > Did you actually see that failure in practice? I don't see
> > how it could happen.
> 
> No, I did not. This patchset does the right thing theoretically, I
> think, but if such problem never happens for GART, I'll drop the patch
> for GART. Joerg?

I am not aware of any failures which are fixed by these patches. But in
theory there could be failures.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

