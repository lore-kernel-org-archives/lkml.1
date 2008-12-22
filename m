Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYLVFfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYLVFfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 00:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYLVFf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 00:35:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:48772 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYLVFf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 00:35:28 -0500
Date: Mon, 22 Dec 2008 14:34:57 +0900
To: jeremy@goop.org
Cc: beckyb@kernel.crashing.org, mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, ian.campbell@citrix.com,
       jbeulich@novell.com, joerg.roedel@amd.com, benh@kernel.crashing.org
Subject: Re: [PATCH 06/11] swiotlb: Store phys address in io_tlb_orig_addr
 array
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <494BDC6E.8050509@goop.org>
References: <20081218210231.GB24271@elte.hu>
	<1229663480-10757-7-git-send-email-beckyb@kernel.crashing.org>
	<494BDC6E.8050509@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081222143507R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 09:39:58 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Becky Bruce wrote:
> > When we enable swiotlb for platforms that support HIGHMEM, we
> > can no longer store the virtual address of the original dma
> > buffer, because that buffer might not have a permament mapping.
> > Change the iotlb code to instead store the physical address of
> > the original buffer.
> >   
> 
> Hm, yes, I think using a phys_addr_t may end up being cleaner than using 
> struct page *+offset.

Surely, cleaner and simpler. Can you please rework [PATCH 07/11] in
that way?
