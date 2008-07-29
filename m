Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYG2FoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYG2FoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYG2Fn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:43:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:47093 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYG2Fn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:43:57 -0400
Date: Tue, 29 Jul 2008 14:42:45 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au, mingo@elte.hu,
       joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080728.222618.74785329.davem@davemloft.net>
References: <20080729135652.f89042c1.sfr@canb.auug.org.au>
	<20080729133909L.fujita.tomonori@lab.ntt.co.jp>
	<20080728.222618.74785329.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080729144135F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 22:26:18 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Tue, 29 Jul 2008 13:38:53 +0900
> 
> > Agreed... As I said before, this is not urgent at all so we didn't
> > need to rush.
> 
> Please, if you are going to add such interface, add
> "const unsigned long io_page_size" argument so that
> powerpc and sparc can use it too.

I didn't add this function:

http://marc.info/?l=linux-kernel&m=121699080831750&w=2

I pointed out that it doesn't work for some architectures:

http://marc.info/?l=linux-kernel&m=121699304403202&w=2


But sorry about not noticing that it breaks SPARC and POWER.
