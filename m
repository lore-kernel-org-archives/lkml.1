Return-Path: <linux-kernel-owner+w=401wt.eu-S1761842AbXFDV1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761842AbXFDV1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXFDV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:27:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbXFDV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:27:22 -0400
Date: Mon, 04 Jun 2007 14:27:36 -0700 (PDT)
Message-Id: <20070604.142736.27799798.davem@davemloft.net>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ATA]: Don't allow to enable this for SPARC64 without PCI.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070604210952.GI20299@havoc.gtf.org>
References: <200706042059.l54Kx6jR031700@hera.kernel.org>
	<20070604210952.GI20299@havoc.gtf.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 4 Jun 2007 17:09:52 -0400

> Um, this was NAK'd:
> 
> libata uses generic DMA and generic struct device.  Neither of which
> are specific to SPARC64 or PCI.
> 
> Did you read the code?
> Did you read the thread on which you were CC'd?
> Did you see the NAKs from me and Alan (and others)?

It went in before any of you replied, to be fair.

I'm willing to fix this in other ways, but there is simply
no hardware that's going to work in that kind of configuration
(non-PCI) on sparc64 so building it in that state is going to
be purely for the purposes of intellectual curiosity :-)
