Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYIVRHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYIVRHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYIVRH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:07:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:38894 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYIVRH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:07:28 -0400
Date: Tue, 23 Sep 2008 02:07:07 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off
 instead of amd_iommu=off"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080922163109.GD24392@amd.com>
References: <20080922142713.GA24392@amd.com>
	<20080922235421A.fujita.tomonori@lab.ntt.co.jp>
	<20080922163109.GD24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080923020639U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 18:31:09 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Sep 23, 2008 at 12:25:23AM +0900, FUJITA Tomonori wrote:
> > I don't think that users need to have iommu=calgary parameter to use
> > calgary IOMMU by default. If you enable CONFIG_CALGARY_IOMMU,
> > CALGARY_IOMMU_ENABLED_BY_DEFAULT is also enabled by default. If a
> > kernel finds calgary IOMMU, the kernel uses it by default.
> > 
> > It's also consistent with how SWIOTLB. Users don't need iommu=soft
> > parameter to enable SWIOTLB. A kernel enables SWIOTLB automatically
> > when necessary.
> 
> Yes. The parameters are usefull if a user wants to enable a specific
> IOMMU implementation. The user could be an IOMMU developer testing
> changes in a special implementation the kernel would not choose by
> default on his machine.
> I like Ingo's idea here. Lets do boths, implementing iommu=$type to
> force a specific iommu implementation and $(type)_iommu=off to disable
> one.

This is exactly what I've been against, something like "I like it and
let do it".

Sure, Ingo's suggestion looks consistent, but these parameters
interact other parameters. If we are serious about improving the IOMMU
parameters, we need to spend more time to think about the final
picture of all the IOMMU parameters that we need.
