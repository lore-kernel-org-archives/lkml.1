Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYANAxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYANAxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 19:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYANAxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 19:53:39 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40966 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752672AbYANAxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 19:53:38 -0500
Date: Mon, 14 Jan 2008 00:49:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: nigel@nigel.suspend2.net
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port
 won't drain
Message-ID: <20080114004959.0f533fef@lxorguk.ukuu.org.uk>
In-Reply-To: <478A95DB.80407@suspend2.net>
References: <20080108115148.GB10546@flint.arm.linux.org.uk>
	<20080108115703.GA27179@flint.arm.linux.org.uk>
	<20080111101721.GA4463@ucw.cz>
	<478A95DB.80407@suspend2.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is printk() enough for 'we've just lost your data' condition? Maybe we
> > should abort suspend if we can't drain fifo?
> 
> No way. Think about this from a users' perspective. No one wants suspend
> to ram or hibernate functionality that works sometimes and not others.
> They want it to work reliably so they don't have to worry about their
> laptop overheating while they're getting on the bus or airplane.
> Aborting isn't an option.

Dumb question on the printk however - what if the port that is sticking
is the console - don't we recurse and die ?
