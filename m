Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZCZXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZCZXQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZCZXQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:16:01 -0400
Received: from outbound-mail-318.bluehost.com ([67.222.54.250]:39470 "HELO
	outbound-mail-318.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753948AbZCZXQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:16:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KzxmkMwHg0x3FUVa5hObNwe5bQZEDTkVdxGeObJUMZFlQIUx/0UQejcGqlBPdlFRR7jXrI5kS+u1Q+bcIzqYva0Mn1Immbja4vYbxS7Lq487qpH86fGPySwvJWv7Wc6p;
Date: Thu, 26 Mar 2009 16:15:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: dwmw2@infradead.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH v4 0/6] PCI: support the ATS capability
Message-ID: <20090326161556.05cdd801@hobbes>
In-Reply-To: <1237795142-6606-1-git-send-email-yu.zhao@intel.com>
References: <1237795142-6606-1-git-send-email-yu.zhao@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009 15:58:56 +0800
Yu Zhao <yu.zhao@intel.com> wrote:

> This patch series implements Address Translation Service support for
> the Intel IOMMU. The PCIe Endpoint that supports ATS capability can
> request the DMA address translation from the IOMMU and cache the
> translation itself. This can alleviate IOMMU TLB pressure and improve
> the hardware performance in the I/O virtualization environment.
> 
> The ATS is one of PCI-SIG I/O Virtualization (IOV) Specifications. The
> spec can be found at: http://www.pcisig.com/specifications/iov/ats/
> (it requires membership).
> 
> 
> Changelog:
> v3 -> v4
>   1, coding style fixes (Grant Grundler)
>   2, support the Virtual Function ATS capability
> 
> v2 -> v3
>   1, throw error message if VT-d hardware detects invalid descriptor
>      on Queued Invalidation interface (David Woodhouse)
>   2, avoid using pci_find_ext_capability every time when reading ATS
>      Invalidate Queue Depth (Matthew Wilcox)
> 
> v1 -> v2
>   added 'static' prefix to a local LIST_HEAD (Andrew Morton)

This is a good sized chunk of new code, and you want it to come through
the PCI tree, right?  It looks like it's seen some review from Grant,
David and Matthew but I don't see any Reviewed-by or Acked-by tags in
there... Anyone willing to provide those?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
