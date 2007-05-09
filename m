Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbXEIWNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbXEIWNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbXEIWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:13:04 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3231 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbXEIWNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:13:02 -0400
Date: Wed, 9 May 2007 23:12:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20070509221253.GC26981@flint.arm.linux.org.uk>
Mail-Followup-To: Pierre Ossman <drzeus-list@drzeus.cx>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46421BB5.7040504@drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 09:06:29PM +0200, Pierre Ossman wrote:
> Russell King wrote:
> > Dug out from the ARM kautobuild...
> >
> > drivers/mmc/host/pxamci.c: In function 'pxamci_cmd_done':
> > drivers/mmc/host/pxamci.c:236: error: 'MMC_ALL_SEND_CID' undeclared (first use in this function)
> > drivers/mmc/host/pxamci.c:236: error: (Each undeclared identifier is reported only once
> > drivers/mmc/host/pxamci.c:236: error: for each function it appears in.)
> > drivers/mmc/host/pxamci.c:237: error: 'MMC_SEND_CSD' undeclared (first use in this function)
> > drivers/mmc/host/pxamci.c:238: error: 'MMC_SEND_CID' undeclared (first use in this function)
> >
> >   
> 
> What are opcode defines doing in the driver?

See the comments immediately above and below its use.

Welcome to buggy hardware.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
