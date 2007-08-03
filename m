Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbXHCJc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbXHCJc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 05:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbXHCJcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 05:32:50 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4925 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbXHCJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 05:32:48 -0400
Date: Fri, 3 Aug 2007 10:32:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Robert Hancock <hancockr@shaw.ca>, Mark Lord <lkml@rtr.ca>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
In-Reply-To: <20070802175711.12bdcaec@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64N.0708031030020.28399@blysk.ds.pg.gda.pl>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca>
 <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
 <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
 <46AA3801.7090204@shaw.ca> <20070728092842.GC26443@flint.arm.linux.org.uk>
 <Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl> <46B1F0CB.9060106@rtr.ca>
 <46B202DE.5000709@shaw.ca> <20070802175711.12bdcaec@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Alan Cox wrote:

> Currently libata PIO is mostly done in the IRQ path. Albert Lee was doing
> some work on that but its actually very hard to fix without doing polled
> PIO.

 Hmm, when the drive signals it is ready for a PIO data transfer can't 
just the interrupt handler mask the originating interrupt and post a 
softirq to handle the case?  That should be rather straightforward.

  Maciej
