Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab0CAO7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:59:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0CAO7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:59:13 -0500
Subject: Re: linux-next: build failure after merge of the final tree (mtd
 related)
From: David Woodhouse <dwmw2@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <20100301204844.68915148.sfr@canb.auug.org.au>
References: <20100301204844.68915148.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 15:59:06 +0100
Message-ID: <1267455546.11061.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 20:48 +1100, Stephen Rothwell wrote:
> Hi David,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mtd/nand/r852.o: In function `.sm_sector_valid':
> (.text+0x5c70): multiple definition of `.sm_sector_valid'
> drivers/mtd/nand/sm_common.o:(.text+0x3c8): first defined here
> drivers/mtd/nand/r852.o: In function `.sm_block_erased':
> (.text+0x50dc): multiple definition of `.sm_block_erased'
> drivers/mtd/nand/sm_common.o:(.text+0x2bc): first defined here
> drivers/mtd/nand/r852.o: In function `.sm_block_valid':
> (.text+0x5be8): multiple definition of `.sm_block_valid'
> drivers/mtd/nand/sm_common.o:(.text+0x340): first defined here
> 
> Caused by commit 9fc51a37a8da84618df7584cad67c078317f6720 ("mtd: common
> module for smartmedia/xD support") from the mtd tree.
> 
> I applied the following patch for today.

Thanks. Are you happy carrying those until I get back to civilisation on
Monday?

-- 
dwmw2

