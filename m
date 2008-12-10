Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYLJJgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYLJJgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYLJJg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:36:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44341 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbYLJJg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:36:26 -0500
Message-ID: <493F8D90.40205@redhat.com>
Date: Wed, 10 Dec 2008 11:36:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: mingo@redhat.com, dwmw2@infradead.org, weidong.han@intel.com,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
References: <20081209141143.GW12816@amd.com>
In-Reply-To: <20081209141143.GW12816@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi,
>
> the two patchsets posted as reply to this email implement KVM device
> passthrough support for AMD IOMMU hardware. The changes to the previous
> posts are descibed below
>
> The first patchset is version 4 of the generic iommu api patchset which
> generalizes the VT-d functions exported to KVM into a common api where
> the AMD IOMMU code can plug into. In this version the patchset was
> rebased to the latest post of Han Weidong's patches.
>
> The second patchset finally implements the KVM device passthrough
> support in the AMD IOMMU code. Together with KVM-79 I successfully
> passed an 10GBit network card into an KVM guest. In this version the
> patchset was changed to remove any device before a protection domain is
> freed instead of printing a BUG. Also the patchset was rebased to the
> updated IOMMU-API patches.
>
> These two patchsets apply in order in top of the latest post of
> Han Weidong's Multiple device assignement support patches. Anybody who
> wants to try this out can pull the whole stuff from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git kvm-amd-iommu
>
> Please give these patches a good review.
>
>   

Ack for the kvm bits.

-- 
error compiling committee.c: too many arguments to function

