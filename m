Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbYISK2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbYISK2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYISK2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:28:37 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37804 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYISK2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:28:37 -0400
Date: Fri, 19 Sep 2008 19:28:13 +0900
To: joerg.roedel@amd.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919100711.GH24392@amd.com>
References: <20080919100711.GH24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919192804A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 12:07:11 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> please pull the updates for the AMD IOMMU driver for the 2.6.28 merge
> window. Most of the patches had been sent to LKML for review and got
> comments. One patch touches the GART driver and was added after an
> objection with a patch previously in this series. Please pull.
> 
> The following changes since commit 74546a8cd9a4e2c26a15a534f0be2f9cc08ae675:
>   Ingo Molnar (1):
>         Revert "fix warning in: "x86: HPET_MSI Initialise per-cpu HPET timers""
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-updates-2.6.28
> 
> FUJITA Tomonori (1):
>       AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
> 
> Joerg Roedel (24):
>       AMD IOMMU: check for invalid device pointers
>       AMD IOMMU: move TLB flushing to the map/unmap helper functions
>       x86: move GART TLB flushing options to generic code

As I wrote, I don't think that this GART patch is the right approach.
