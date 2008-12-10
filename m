Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYLJOMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYLJOMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYLJOL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:11:57 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:49753 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYLJOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:11:56 -0500
X-BigFish: VPS-28(zba6iz1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBNZF6-03-JIC-01
Date: Wed, 10 Dec 2008 15:11:31 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, dwmw2@infradead.org
CC: mingo@redhat.com, weidong.han@intel.com, torvalds@linux-foundation.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
Message-ID: <20081210141131.GB12816@amd.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <493F8D90.40205@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Dec 2008 14:11:31.0953 (UTC) FILETIME=[33BE1610:01C95AD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 11:36:16AM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
> >Hi,
> >
> >the two patchsets posted as reply to this email implement KVM device
> >passthrough support for AMD IOMMU hardware. The changes to the previous
> >posts are descibed below
> >
> >The first patchset is version 4 of the generic iommu api patchset which
> >generalizes the VT-d functions exported to KVM into a common api where
> >the AMD IOMMU code can plug into. In this version the patchset was
> >rebased to the latest post of Han Weidong's patches.
> >
> >The second patchset finally implements the KVM device passthrough
> >support in the AMD IOMMU code. Together with KVM-79 I successfully
> >passed an 10GBit network card into an KVM guest. In this version the
> >patchset was changed to remove any device before a protection domain is
> >freed instead of printing a BUG. Also the patchset was rebased to the
> >updated IOMMU-API patches.
> >
> >These two patchsets apply in order in top of the latest post of
> >Han Weidong's Multiple device assignement support patches. Anybody who
> >wants to try this out can pull the whole stuff from
> >
> >git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git kvm-amd-iommu
> >
> >Please give these patches a good review.
> >
> >  
> 
> Ack for the kvm bits.

Thanks Avi.

So now its open how this will be merged alltogether. We can merge it in
three steps (first from Dave's tree, then Avi and at last my IOMMU
updates which has to happen in that order).
The other option is to merge this all with one pull-request I send to
Linus. It should not conflict with your updates Avi because all these
changes apply also cleanly to current linus/master.
Is this acceptable for everyone?

David, its important to hear your opinion on that because this single
pull-request would include all VT-d updates you have queued in your
tree? Is this ok for you?

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

