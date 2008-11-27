Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYK0QdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYK0QdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYK0QdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:33:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53654 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYK0QdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:33:09 -0500
Message-ID: <492ECBB8.6070509@redhat.com>
Date: Thu, 27 Nov 2008 18:32:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, weidong.han@intel.com,
       mingo@redhat.com, dwmw2@infradead.org, amit.shah@redhat.com
Subject: Re: [PATCH 1/9] KVM: rename vtd.c to iommu.c
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com> <1227800454-9555-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1227800454-9555-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Impace: file renamed
>
>   

"impact"?

> The code in the vtd.c file can be reused for other IOMMUs as well. So
> rename it to make it clear that it handle more than VT-d.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/ia64/kvm/Makefile |    2 +-
>  arch/x86/kvm/Makefile  |    2 +-
>  virt/kvm/iommu.c       |  191 ++++++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/vtd.c         |  191 ------------------------------------------------
>   

Use the git -M switch, which show renames as renames instead of 
removes+adds.

-- 
error compiling committee.c: too many arguments to function

