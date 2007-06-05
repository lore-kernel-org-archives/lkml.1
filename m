Return-Path: <linux-kernel-owner+w=401wt.eu-S932793AbXFEQLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbXFEQLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764767AbXFEQLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:11:05 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43176 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764558AbXFEQLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:11:04 -0400
Date: Tue, 5 Jun 2007 12:10:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
Message-ID: <20070605161052.GL31565@havoc.gtf.org>
References: <1181055308.14054.36.camel@localhost.localdomain> <1181055396.14054.38.camel@localhost.localdomain> <1181055483.14054.40.camel@localhost.localdomain> <20070605170747.256f6631@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605170747.256f6631@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 05:07:47PM +0100, Alan Cox wrote:
> Add an lguest check to go with the pci check and for the lguest case just
> say "no controllers"
> 
> Better yet just don't compile in the old IDE stuff, lguest doesn't have a
> PCI or ISA bus anyway.
> 
> Alternatively make the IDE I/O space return 0xFF and it'll skip them
> anyway.

ACK to any of these suggestions...  agreed.

	Jeff



