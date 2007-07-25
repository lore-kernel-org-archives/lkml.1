Return-Path: <linux-kernel-owner+w=401wt.eu-S1765484AbXGYNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765484AbXGYNRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbXGYNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:17:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32956 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614AbXGYNRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:17:42 -0400
Date: Wed, 25 Jul 2007 14:17:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: create hw_irq.h
Message-ID: <20070725131738.GA7043@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <200707251207.l6PC7KiH032176@goober> <20070725121724.GA4923@infradead.org> <46A74415.7000408@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A74415.7000408@snapgear.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 10:37:41PM +1000, Greg Ungerer wrote:
> Christoph Hellwig wrote:
> >On Wed, Jul 25, 2007 at 10:07:20PM +1000, Greg Ungerer wrote:
> >>Need an include/asm-m68knommu/hw_irq.h for kernel/hrtimer.c
> >
> >hrtimer.c should be fixed not to include it instead.
> 
> Indirectly it is coming from include/linux/irq.h
> (which means that compilation of a few kernel/irq/*.c files
> fail on m68knommu without hw_irq.h existing too)

sorry.  m68knommu uses genirq now and it'll have to provide hw_irq.h.
Generic code just shouldn't include it direclty.

Objection to the patch taken back.

(And yes, long-term we need to fix up the mess of irq-related headers,
 and Al announced he's gonna start that once 2.6.23 is out)

