Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbYIJDkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbYIJDkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYIJDj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:39:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:60578 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYIJDj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:39:56 -0400
Date: Wed, 10 Sep 2008 12:38:25 +0900
To: zaitcev@redhat.com
Cc: jdmason@kudzu.us, muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: Calgary and bad_dma_address
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080909211941.0a0fda6a.zaitcev@redhat.com>
References: <20080909211941.0a0fda6a.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910123853F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 21:19:41 -0600
Pete Zaitcev <zaitcev@redhat.com> wrote:

> Hi, guys:
> 
> I was reading arch/x86/kernel/pci-calgary_64.c today, and noticed that
> apparently nothing prevents iommu_area_alloc from returning a zero.
> But bad_dma_address is zero too. Doesn't it concern anyone?
> If the first allocation asks for a page-aligned buffer to be mapped,
> a spurious bad address will result, if I understand this right.

Does calgary_reserve_regions() prevent that?
