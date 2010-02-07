Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0BGMXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 07:23:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0BGMXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 07:23:23 -0500
Message-ID: <4B6EB08B.9090705@redhat.com>
Date: Sun, 07 Feb 2010 14:22:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-7-git-send-email-joerg.roedel@amd.com> <20100128222455.GA26274@amt.cnet> <20100129093233.GU17809@8bytes.org> <20100201141804.GD16236@amd.com> <20100201193017.GA27065@amt.cnet> <20100205110145.GZ16236@amd.com>
In-Reply-To: <20100205110145.GZ16236@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2010 01:01 PM, Joerg Roedel wrote:
>
>> Yes, addresses the concern.
>>      
> Are there any further objections against this patchset? If not it would
> be cool if you could give me some acks for the kvm specific parts of
> this patchset.
>    

There are two ways we can get the kvm bits in:

- you publish a git tree excluding the kvm patches, I merge your tree, 
then apply the kvm specific patches.  This is best for avoiding 
merge-time conflicts if I get other patches for the same area.
- you push everything including the kvm bits.

I'm fine with both, though prefer the former.  If you choose the latter, 
ACK for the kvm patches.

-- 
error compiling committee.c: too many arguments to function

