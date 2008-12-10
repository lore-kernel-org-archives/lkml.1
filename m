Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYLJOZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYLJOZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYLJOZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:25:42 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21652 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYLJOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:25:41 -0500
X-BigFish: VPS-37(zba6iz1432R98dR936eQ1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBO02D-04-WVJ-01
Date: Wed, 10 Dec 2008 15:25:25 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Avi Kivity <avi@redhat.com>, mingo@redhat.com, weidong.han@intel.com,
       torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
Message-ID: <20081210142525.GC12816@amd.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com> <20081210141131.GB12816@amd.com> <1228918928.21454.27.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1228918928.21454.27.camel@macbook.infradead.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Dec 2008 14:25:25.0612 (UTC) FILETIME=[24A45AC0:01C95AD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 02:22:08PM +0000, David Woodhouse wrote:
> On Wed, 2008-12-10 at 15:11 +0100, Joerg Roedel wrote:
> > So now its open how this will be merged alltogether. We can merge it in
> > three steps (first from Dave's tree, then Avi and at last my IOMMU
> > updates which has to happen in that order).
> > The other option is to merge this all with one pull-request I send to
> > Linus. It should not conflict with your updates Avi because all these
> > changes apply also cleanly to current linus/master.
> > Is this acceptable for everyone?
> > 
> > David, its important to hear your opinion on that because this single
> > pull-request would include all VT-d updates you have queued in your
> > tree? Is this ok for you?
> 
> Yes, that's fine by me. Should I apply patches 1-14 of Weidong's patch
> set from Monday first? Or just let you do that?

I already did it on-top of your tree because Han Weidong's patches 1-17
were rebased to your tree and my IOMMU-API patches apply on-top of his
patches.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

