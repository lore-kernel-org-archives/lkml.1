Return-Path: <linux-kernel-owner+w=401wt.eu-S1030820AbXAZIR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030820AbXAZIR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 03:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030822AbXAZIR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 03:17:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41728
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030820AbXAZIR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 03:17:26 -0500
Date: Fri, 26 Jan 2007 00:17:25 -0800 (PST)
Message-Id: <20070126.001725.18306982.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0701252208050.25027@woody.linux-foundation.org>
References: <1169788181.3593.250.camel@shinybook.infradead.org>
	<Pine.LNX.4.64.0701252125280.25027@woody.linux-foundation.org>
	<Pine.LNX.4.64.0701252208050.25027@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jan 2007 22:18:21 -0800 (PST)

> So on sparc64, "ioport_resource" really is just a container for the actual 
> per-domain resource buckets that the hardware (within that domain) will 
> then do the resource allocation from. Afaik.
> 
> But you should actaully verify that with somebody like Davem if you 
> _really_ care.  I cc'd him in case he wants to pipe up and perhaps prove 
> me wrong.

They are all physical addresses of the I/O locations.

It just so happens that all the non-memory physicall addresses
have some high bit set.

So it all works out, but not intentionally, it's merely a side
effect of how the physical address space is layed out.
