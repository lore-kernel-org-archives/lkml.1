Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbXGIJqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbXGIJqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXGIJqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:46:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36224 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbXGIJqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:46:10 -0400
Date: Mon, 9 Jul 2007 10:51:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Message-ID: <20070709105123.1df728b2@the-village.bc.nu>
In-Reply-To: <4691A196.7080305@goop.org>
References: <20070617214231.GA3588@stusta.de>
	<46760D87.2000502@goop.org>
	<20070708224444.GU3492@stusta.de>
	<4691A196.7080305@goop.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jul 2007 19:46:46 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Adrian Bunk wrote:
> >>> Reverting is safe since it simply re-establishes the 2.6.21 status quo.
> >>>       
> >> Well, not really.  It breaks any non-GPL module when CONFIG_PARAVIRT is
> >> enabled, even though the same module would work fine otherwise.  That's
> >> a pretty large regression.
> >> ...
> >>     
> >
> > The 2.6.21 status quo can by definition not be a regression compared
> > to 2.6.21.
> >   
> 
> 2.6.21's behaviour was a bug.  CONFIG_PARAVIRT is not supposed to cause 
> any behavioural changes.

2.6.22's behaviour is the bug. 2.6.21 you couldn't load random binary
crap into the kernel without logging a taint. 2.6.22 you can. This means
every single 2.6.22 bug report has to be assumed to be caused by binary
module crap as a starting point which slows down debug immensely.

Alan
