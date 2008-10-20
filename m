Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbYJTHVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbYJTHVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYJTHVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:21:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJTHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:21:35 -0400
Subject: Re: [PATCH] intel-iommu: use coherent_dma_mask in alloc_coherent
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mgross@linux.intel.com, mingo@elte.hu, grundler@parisc-linux.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081020093824G.fujita.tomonori@lab.ntt.co.jp>
References: <20081015160732K.fujita.tomonori@lab.ntt.co.jp>
	 <1224337616.6770.1366.camel@macbook.infradead.org>
	 <20081020093824G.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 08:21:02 +0100
Message-Id: <1224487262.6770.1505.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 09:46 +0900, FUJITA Tomonori wrote:
> > I've fixed this up to cope with the fact that dma_mask can be bigger
> > than an 'unsigned long', and committed it to the iommu-2-6.git tree.
> 
> Hmm, 'unsigned long' is 64 bits on IA64 and X86_64. How can dma_mask
> be bigger than an 'unsigned long'?

On i386.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

