Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZLBIIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZLBIIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZLBIIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:08:04 -0500
Received: from sh.osrg.net ([192.16.179.4]:50617 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZLBIID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:08:03 -0500
Date: Wed, 2 Dec 2009 17:07:24 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B161D70.3030301@kernel.org>
References: <4B160FE1.1090307@kernel.org>
	<20091202162510Q.fujita.tomonori@lab.ntt.co.jp>
	<4B161D70.3030301@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091202170715K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 02 Dec 2009 17:07:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Dec 2009 23:55:28 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> >>>> amd 64 systems that
> >>>> 1. do not have  AGP
> >>>> 2. do not have IOMMU
> >>>> 3. mem > 4g
> >>>> 4. BIOS do not allocate  correct gart in NB.
> >>>> will leave them to use SWIOTLB forcely.
> >>> As I asked earlier, can you tell me what dma ops such system is
> >>> supposed to use?
> >> gart_dma_ops
> > 
> > How does gart_dma_ops work on systems without IOMMU?
> 
> ?

If a system doesn't have IOMMU, what does gart_dma_ops do?


> >>>> -v4: disable translating in early_gart_iommu_check according to FUJITA
> >>> Why can't we always disable translation in early_gart_iommu_check? We
> >>> really need search_agp_bridge() in early_gart_iommu_check()?
> >> just don't want to messed them up.
> > 
> > Sorry, I can't follow you. What does 'always disabling' mess up?
> 
> the AMD K8 system with AGP etc...those systems are some kind of 5 years old.
> 
> and don't have those kind of system to verify...

Ok.
