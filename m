Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZEKDmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZEKDmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZEKDlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:41:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:40165 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZEKDls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:41:48 -0400
Date: Mon, 11 May 2009 12:40:38 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 4/9] xen/swiotlb: add swiotlb_arch_range_needs_mapping
 hook for xen
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1241741842-7966-5-git-send-email-jeremy@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
	<1241741842-7966-5-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090511122715L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 12:40:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 May 2009 17:17:17 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Impact: Xen support for DMA
> 
> Add hook so that Xen can determine whether a particular address range needs
> pfn<->mfn mapping.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-swiotlb.c |    5 -----
>  arch/x86/xen/pci-swiotlb.c    |    8 ++++++++
>  drivers/pci/xen-iommu.c       |    5 +++++
>  include/xen/swiotlb.h         |    1 +
>  4 files changed, 14 insertions(+), 5 deletions(-)
> 

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
