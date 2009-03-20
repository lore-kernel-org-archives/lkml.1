Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZCTCad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZCTCad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZCTCaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:30:23 -0400
Received: from outbound-mail-07.bluehost.com ([69.89.17.207]:59939 "HELO
	outbound-mail-07.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752613AbZCTCaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:30:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SxibpX3lc7Np/LvyWpasDxE0l6CBYnN34tr/Y45Wh29Qof8mWC2Mq3HNXl65hreHeXq04UvKB7sRDBX9+csHOsmuOjGKDnKrawzgi0R/RGDPZbSIT559HddOQ0W2G3eZ;
Date: Thu, 19 Mar 2009 19:30:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: dwmw2@infradead.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
Message-ID: <20090319193013.66eaa539@hobbes.lan>
In-Reply-To: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 20:50:32 +0800
Yu Zhao <yu.zhao@intel.com> wrote:

> This patch series implements Address Translation Service support for
> the Intel IOMMU. ATS makes the PCI Endpoint be able to request the
> DMA address translation from the IOMMU and cache the translation in
> the Endpoint, thus alleviate IOMMU pressure and improve the hardware
> performance in the I/O virtualization environment.
> 
> 
> Changelog: v2 -> v3
>   1, throw error message if VT-d hardware detects invalid descriptor
>      on Queued Invalidation interface (David Woodhouse)
>   2, avoid using pci_find_ext_capability every time when reading ATS
>      Invalidate Queue Depth (Matthew Wilcox)
> Changelog: v1 -> v2
>   added 'static' prefix to a local LIST_HEAD (Andrew Morton)
> 
> 
> Yu Zhao (6):
>   PCI: support the ATS capability
>   VT-d: parse ATSR in DMA Remapping Reporting Structure
>   VT-d: add queue invalidation fault status support
>   VT-d: add device IOTLB invalidation support
>   VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
>   VT-d: support the device IOTLB

Is this one ready too, Yu?  Care to send a respin incorporating the
last set of feedback?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
