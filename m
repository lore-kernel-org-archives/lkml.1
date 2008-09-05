Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYIEJNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYIEJNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYIEJM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:12:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:49759 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYIEJM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:12:56 -0400
Date: Fri, 5 Sep 2008 18:11:41 +0900
To: mingo@redhat.com
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] fix alloc_coherent allocation issues
 (tip/x86/iommu)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080905181155W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Sep 2008 17:58:46 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This patchset restores some of the current alloc_coherent behaviors
> that Joerg's x86 patchset (in tip/x86/iommu) changes.
> 
> The first patch uses __GFP_DMA for NULL device argument (fallback_dev)
> with pci-nommu. It's a hack for ISA (and some old code) so we need
> DMA_ZONE.
> 
> The second patch uses __GFP_NORETRY in the case of GFP_DMA.
> 
> The third patch is a minor cleanup.

Oops, I messed up the subjects. They should have been:

[PATCH 1/3] x86: fix nommu_alloc_coherent allocation with NULL device argument
[PATCH 2/3] x86: use __GFP_NORETRY in the case of GFP_DMA with pci-nommu
[PATCH 3/3] x86: gart alloc_coherent doesn't need to check NULL device argument

