Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYIQTXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYIQTXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYIQTXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:23:39 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34020 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYIQTXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:23:39 -0400
Date: Thu, 18 Sep 2008 04:20:20 +0900
To: joerg.roedel@amd.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 18/23] AMD IOMMU: simplify dma_mask_to_pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1221670377-19295-19-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
	<1221670377-19295-19-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080918041717S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 18:52:52 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> The current calculation is very complicated. This patch replaces it with
> a much simpler version.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

I think that you can use iommu_device_max_index() for what
dma_mask_to_pages does.
