Return-Path: <linux-kernel-owner+w=401wt.eu-S1161044AbXAZPci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161044AbXAZPci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161045AbXAZPci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:32:38 -0500
Received: from rtr.ca ([64.26.128.89]:1833 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161044AbXAZPch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:32:37 -0500
Message-ID: <45BA1F13.60908@rtr.ca>
Date: Fri, 26 Jan 2007 10:32:35 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
References: <20070125150905.652f9ce2@localhost.localdomain>	 <1169741658.3593.98.camel@shinybook.infradead.org>	 <20070125172739.0c990a9a@localhost.localdomain>	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>	 <1169770985.3593.146.camel@shinybook.infradead.org>	 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>	 <1169778239.3593.195.camel@shinybook.infradead.org>	 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org> <1169782107.3593.219.camel@shinybook.infradead.org>
In-Reply-To: <1169782107.3593.219.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not as if people should be pulling 'raw' IRQ numbers out
> of a hat or even module parameters these days, except for ISA drivers..

Err.. in the embedded space, this is exceptionally common today,
on the most modern of chips, too.  Lots of magic hard(ware)-coded IRQ numbers.

Cheers
