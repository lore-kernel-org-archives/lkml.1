Return-Path: <linux-kernel-owner+w=401wt.eu-S1751507AbYJSLU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbYJSLU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 07:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYJSLUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 07:20:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYJSLUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 07:20:12 -0400
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       fenghua.yu@intel.com, tony.luck@intel.com, suresh.b.siddha@intel.com,
       sfr@canb.auug.org.au, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20081019111203.GB29705@8bytes.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	 <20081019111203.GB29705@8bytes.org>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 12:19:58 +0100
Message-Id: <1224415198.6770.1464.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 13:12 +0200, Joerg Roedel wrote:
> On Sat, Oct 18, 2008 at 04:30:43PM +0100, David Woodhouse wrote:
> > As previously threatened, I've created an iommu-2.6.git tree:
> > 	git://git.infradead.org/iommu-2.6.git
> > 	http://git.infradead.org/iommu-2.6.git
> 
> Is there a specific reason why IOMMU stuff should go to Linus without
> testing them in the x86 tree before? The DMA layer and IOMMU drivers are
> an integral component of the architecture and patches for it are best
> placed in the architecture tree instead of a seperate one, imho.

This is the purpose that linux-next serves, not the x86 forest-of-doom.

And I thought Ingo said his old iommu tree wasn't in there anyway? He
said it was somewhere else, although I haven't actually managed to
_find_ it.

The Intel IOMMU appears on IA64 too, and doesn't want to be developed
and tested off in an x86-specific corner by itself. And I'm going to be
looking at other generic things we can do to improve IOMMU-related
performance, which will touch on other architectures too.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

