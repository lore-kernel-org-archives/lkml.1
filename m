Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0BGMl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 07:41:28 -0500
Received: from 8bytes.org ([88.198.83.132]:42466 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0BGMl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 07:41:27 -0500
Date: Sun, 7 Feb 2010 13:41:26 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large
	pages
Message-ID: <20100207124126.GA23725@8bytes.org>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-7-git-send-email-joerg.roedel@amd.com> <20100128222455.GA26274@amt.cnet> <20100129093233.GU17809@8bytes.org> <20100201141804.GD16236@amd.com> <20100201193017.GA27065@amt.cnet> <20100205110145.GZ16236@amd.com> <4B6EB08B.9090705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6EB08B.9090705@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 02:22:35PM +0200, Avi Kivity wrote:
> On 02/05/2010 01:01 PM, Joerg Roedel wrote:
>>
>>> Yes, addresses the concern.
>>>      
>> Are there any further objections against this patchset? If not it would
>> be cool if you could give me some acks for the kvm specific parts of
>> this patchset.
>>    
>
> There are two ways we can get the kvm bits in:
>
> - you publish a git tree excluding the kvm patches, I merge your tree,  
> then apply the kvm specific patches.  This is best for avoiding  
> merge-time conflicts if I get other patches for the same area.
> - you push everything including the kvm bits.
>
> I'm fine with both, though prefer the former.  If you choose the latter,  
> ACK for the kvm patches.

Hmm, the patch set is self-contained and hard to split. We had the same
problem with the initial iommu-api merge. Since I have further updates
for the AMD IOMMU driver I think its best to send the these patches and
my updates directly to Linus after the KVM updates are merged in the
next merge window. Thanks for your ACKs :-)

	Joerg

