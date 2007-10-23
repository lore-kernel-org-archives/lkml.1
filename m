Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbXJWR2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbXJWR2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXJWR2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:28:01 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:43158 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbXJWR17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:27:59 -0400
Date: Tue, 23 Oct 2007 18:27:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: Fix the baud_table check in encode_baud_rate
In-Reply-To: <20071017114358.3d2b166f@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64N.0710231823530.8693@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0710161857280.22596@blysk.ds.pg.gda.pl>
 <20071017114358.3d2b166f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Alan Cox wrote:

> >  The tty_termios_encode_baud_rate() function as defined by tty_ioctl.c has 
> > a problem with the baud_table within.  The comparison operators are 
> > reversed and as a result this table's entries never match and BOTHER is 
> > always used.
> 
> Oops. I thought I'd fixed that one. Bit bothersome its been in -mm that
> long before anyone noticed. 

 -ENOTENOUGHUSERS?

> >  Additionally this function's prototype is not exported unlike the 
> > function itself.
> 
> That bit seems out of date and a prototype was added later in -mm

 Given the function has survived for quite a while without a prototype 
exported (how to use it otherwise? -- I guess set_sgttyb() does not count 
as hardly anybody should be calling it), I suppose it is no surprise it 
was not adequately tested. ;-)

  Maciej
