Return-Path: <linux-kernel-owner+w=401wt.eu-S965185AbZLHA0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185AbZLHA0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935725AbZLHA0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:26:11 -0500
Received: from sh.osrg.net ([192.16.179.4]:41752 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935718AbZLHA0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:26:10 -0500
Date: Tue, 8 Dec 2009 09:24:47 +0900
To: yinghai@kernel.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091202170715K.fujita.tomonori@lab.ntt.co.jp>
References: <20091202162510Q.fujita.tomonori@lab.ntt.co.jp>
	<4B161D70.3030301@kernel.org>
	<20091202170715K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091208092438Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 08 Dec 2009 09:24:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Dec 2009 17:07:24 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 01 Dec 2009 23:55:28 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > >>>> amd 64 systems that
> > >>>> 1. do not have  AGP
> > >>>> 2. do not have IOMMU
> > >>>> 3. mem > 4g
> > >>>> 4. BIOS do not allocate  correct gart in NB.
> > >>>> will leave them to use SWIOTLB forcely.
> > >>> As I asked earlier, can you tell me what dma ops such system is
> > >>> supposed to use?
> > >> gart_dma_ops
> > > 
> > > How does gart_dma_ops work on systems without IOMMU?
> > 
> > ?
> 
> If a system doesn't have IOMMU, what does gart_dma_ops do?

Ping?

I don't understand the above but the patch is fine about fixing two
things:

- swiotlb wrongly steals the preallocate memory for broken gart.

- a system without agp should disable gart on shutdown.
