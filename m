Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYDRILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYDRILq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYDRILb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:11:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYDRIL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:11:29 -0400
Date: Fri, 18 Apr 2008 04:11:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080418081113.GA789@infradead.org>
References: <20080416202338.GA6007@elte.hu> <20080417232747.4c04f413.akpm@linux-foundation.org> <20080417.233856.238029159.davem@davemloft.net> <20080418074736.GA27579@elte.hu> <20080418010008.2fb29e5c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418010008.2fb29e5c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 01:00:08AM -0700, Andrew Morton wrote:
> On Fri, 18 Apr 2008 09:47:42 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > so i'm not sure where those "over a megabyte of warnings" come from.
> 
> allmodconfig.
> 
> In file included from include/linux/mm.h:39,
>                  from include/linux/scatterlist.h:6,
>                  from include/asm/dma-mapping.h:4,
>                  from include/linux/dma-mapping.h:52,
>                  from include/asm/pci.h:6,
>                  from include/linux/pci.h:945,
>                  from drivers/ata/ata_generic.c:21:
> include/asm/pgtable.h: In function `set_pte_at':
> include/asm/pgtable.h:670: warning: `init_mm' is deprecated (declared at include/linux/sched.h:1616)

Why is is deprecated anyway?  I think we all agreed that killing the
export is good, but I don't see any way how we could kill the core
useage.
