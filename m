Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbYCCRsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbYCCRsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYCCRsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:48:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59933 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755273AbYCCRsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:48:12 -0500
Date: Mon, 3 Mar 2008 17:33:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
Message-ID: <20080303173340.55a38c6b@core>
In-Reply-To: <200803040416.33937.nickpiggin@yahoo.com.au>
References: <20080303120842.GA28369@elf.ucw.cz>
	<Pine.LNX.4.44L0.0803031023550.3611-100000@iolanthe.rowland.org>
	<20080303155330.39e45ad4@core>
	<200803040416.33937.nickpiggin@yahoo.com.au>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you sure gcc doesn't? Or is it just "C"?

gcc doesn't

> Linux wouldn't work today if gcc did something non-atomic there
> (presuming you're talking about naturally aligned pointers/ints).
> It is widely used and accepted.

Yes and we've had tty layer traces in the past clearly showing it isn't
always safe, especially if any math is involved anywhere near the
assignment. That may be why pointer flipping happens to work.

Alan
