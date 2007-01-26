Return-Path: <linux-kernel-owner+w=401wt.eu-S1030738AbXAZExZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030738AbXAZExZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030739AbXAZExZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:53:25 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42548 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030738AbXAZExY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:53:24 -0500
Message-ID: <45B98932.5010006@pobox.com>
Date: Thu, 25 Jan 2007 23:53:06 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
References: <20070125150905.652f9ce2@localhost.localdomain> <1169741658.3593.98.camel@shinybook.infradead.org> <20070125172739.0c990a9a@localhost.localdomain> <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org> <1169770985.3593.146.camel@shinybook.infradead.org> <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org> <1169778239.3593.195.camel@shinybook.infradead.org> <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org> <1169782107.3593.219.camel@shinybook.infradead.org>
In-Reply-To: <1169782107.3593.219.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> When I eventually get to go home, which will hopefully still be some
> time this month, I'll give some more coherent thought to the idea of
> just using a (struct irq_desc *) directly instead of an integer. Then

Tejun beat you to it with devres.  devres makes all sorts of resource 
allocation and tracking loads easier.

Learn it, love it, lick it.

:)

	Jeff


