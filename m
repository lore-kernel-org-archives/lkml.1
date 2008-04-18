Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYDRITX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYDRITX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYDRITD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:19:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46389
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754958AbYDRIS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:18:57 -0400
Date: Fri, 18 Apr 2008 01:18:58 -0700 (PDT)
Message-Id: <20080418.011858.228414800.davem@davemloft.net>
To: hch@infradead.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       arjan@infradead.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080418081113.GA789@infradead.org>
References: <20080418074736.GA27579@elte.hu>
	<20080418010008.2fb29e5c.akpm@linux-foundation.org>
	<20080418081113.GA789@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 18 Apr 2008 04:11:21 -0400

> On Fri, Apr 18, 2008 at 01:00:08AM -0700, Andrew Morton wrote:
> > On Fri, 18 Apr 2008 09:47:42 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > so i'm not sure where those "over a megabyte of warnings" come from.
> > 
> > allmodconfig.
> > 
> > In file included from include/linux/mm.h:39,
> >                  from include/linux/scatterlist.h:6,
> >                  from include/asm/dma-mapping.h:4,
> >                  from include/linux/dma-mapping.h:52,
> >                  from include/asm/pci.h:6,
> >                  from include/linux/pci.h:945,
> >                  from drivers/ata/ata_generic.c:21:
> > include/asm/pgtable.h: In function `set_pte_at':
> > include/asm/pgtable.h:670: warning: `init_mm' is deprecated (declared at include/linux/sched.h:1616)
> 
> Why is is deprecated anyway?  I think we all agreed that killing the
> export is good, but I don't see any way how we could kill the core
> useage.

set_pte_at() is done inside drivers and what-not, you're not
going to be able to get rid of this export so easily.
