Return-Path: <linux-kernel-owner+w=401wt.eu-S1761218AbYHUXVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218AbYHUXVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHUXVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:21:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:58345 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbYHUXVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:21:10 -0400
Date: Fri, 22 Aug 2008 08:19:35 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] x86: make gart_alloc_coherent return zeroed memory
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1219339707-30592-1-git-send-email-joerg.roedel@amd.com>
References: <20080821225038E.fujita.tomonori@lab.ntt.co.jp>
	<1219339707-30592-1-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080822081517F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 19:28:27 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> The dma_alloc_coherent function should return memory set to zero. This patch
> adds this to the GART implementation.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-gart_64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

This should be foiled to the first patch in the patchset. No good
reason to push a patch that might cause a problem.
