Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXDIK4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXDIK4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 06:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXDIK4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 06:56:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53394 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXDIK4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 06:56:47 -0400
Message-ID: <461A1BEA.7000002@pobox.com>
Date: Mon, 09 Apr 2007 06:56:42 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] pata_icside driver
References: <20070330110022.GA21653@flint.arm.linux.org.uk>	<20070330110800.GB21653@flint.arm.linux.org.uk>	<20070408101826.GA5431@flint.arm.linux.org.uk>	<20070408195956.4e7d50c0@the-village.bc.nu>	<461990CE.8080609@pobox.com> <20070409105638.6b131b72@the-village.bc.nu>
In-Reply-To: <20070409105638.6b131b72@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Then no SFF hardware can use ata_irq_ack. Not one card: Because in every

OK


> We should just rename ata_irq_ack(). It is in libata-sff, so it's either
> wrong (missing a test), or in the wrong file completely.

There is plenty of BMDMA-specific stuff in libata-sff, so neither 
assertion is correct.

It's fine to rename it, though.

	Jeff


