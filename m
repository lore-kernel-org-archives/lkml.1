Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZHMHPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZHMHPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZHMHPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:15:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:39531 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZHMHPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:15:30 -0400
Date: Thu, 13 Aug 2009 16:14:46 +0900
To: luming.yu@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, fenghua.yu@intel.com, dwmw2@infradead.org,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
References: <3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
	<20090813155118P.fujita.tomonori@lab.ntt.co.jp>
	<3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 16:14:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 15:03:20 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> Thanks for another workaround, we should be working on deleting wrong
> assumption of"iommu_deteced == iommu working", Not just workaround. My
> patch could break something.. but it is just a start towards right
> goal..

As I explained, your patch doesn't go toward the right goal.

And if you want to fix this problem right now, my workaround patch is
much better than yours; it doesn't waste 64MB.
