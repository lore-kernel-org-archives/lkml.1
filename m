Return-Path: <linux-kernel-owner+w=401wt.eu-S939244AbXG3Jpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939244AbXG3Jpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935502AbXG3JpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:45:23 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4557 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765986AbXG3JpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:45:21 -0400
Date: Mon, 30 Jul 2007 10:45:19 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Robert Hancock <hancockr@shaw.ca>, Lee Howard <faxguy@howardsilvan.com>,
       linux-serial@vger.kernel.org, tytso@mit.edu,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
In-Reply-To: <20070728092842.GC26443@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca>
 <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
 <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
 <46AA3801.7090204@shaw.ca> <20070728092842.GC26443@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007, Russell King wrote:

> Essentially, any complex interrupt handler (such as an IDE interrupt
> doing a multi-sector PIO transfer _in interrupt context_) can cause this
> kind of starvation.  That's why Linux 1.x had bottom halves - so that
> the time consuming work could be moved out of the interrupt handler,
> thereby causing minimal the blockage of other interrupts.
> 
> Unfortunately, that kind of design has been long since forgotten.
> Apparantly modern machines are fast enough that it doesn't have to be
> worried about anymore...  Or are they?

 I would guess it is not that the machines are fast enough, but that this 
two-level processing makes things more complicated.  Enough that most 
people would not bother digging into it unless really forced.  Only 
occasional latency problems are probably not enough of a force.

  Maciej
