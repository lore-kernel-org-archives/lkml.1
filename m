Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbXEKBRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbXEKBRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbXEKBRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:17:45 -0400
Received: from ozlabs.org ([203.10.76.45]:38750 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbXEKBRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:17:45 -0400
Subject: [PATCH 0/5] lguest feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
       Christoph Hellwig <hch@infradead.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain
Date: Fri, 11 May 2007 11:17:26 +1000
Message-Id: <1178846246.23513.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	Gratefully-received recent feedback from CC'd was applied to excellent
effect (and the advice from Matt Mackall about my personal appearance is
best unrequited).

	The patch is split in 5 parts to correspond with the 9 parts Andrew
sent out before, but here's the summary:

1) Sparse (thanks Christoph Hellwig):
    - lguest_const can be static now
    - lguest.c should include "lguest_bus.h" for lguest_devices declaration.
    - page_tables.c unnecessary initialization
    - But the cost was high: lots of __force casts 8(
2) Jeff Garzik
    - Use netdev_priv instead of dev->priv.
    - Check for ioremap failure
    - iounmap on failure.
    - Wrap SEND_DMA and BIND_DMA calls
    - Don't set NETIF_F_SG unless we set NETIF_F_NO_CSUM
    - Use SET_NETDEV_DEV()
    - Don't set dev->irq, mem_start & mem_end (deprecated)
3) Sam Ravnborg
    - lg-objs is deprecated, use lg-y.

Cheers,
Rusty.

