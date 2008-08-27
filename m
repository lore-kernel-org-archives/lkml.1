Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYH0Wqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYH0Wqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYH0Wq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:46:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34116 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752437AbYH0Wq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:46:27 -0400
Date: Wed, 27 Aug 2008 23:28:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080827232803.2ba8dd96@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	<alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org>
	<m3k5e2qkk2.fsf@telia.com>
	<20080827230828.4285022b@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, why is unlocked_ioctl returning "long"? Does anybody depend on that 
> too? That's another difference between the "unlocked" and the traditional 
> version..

I don't know - a lot of syscall returns got defined as long and I guess
someone thought propogating the right type was a good diea ?
> 
> As to the "x86 cases", I think you should try to hit them all. Doing a 
> "git grep unlocked_ioctl" gets 185 entries, and it looks like only 
> something like 8 of them are non-x86 (3 in the arch/ directory, five in 
> s390 drivers).
> 
> Of course, some of them may be drivers that aren't available on x86 for 
> other reasons (ie the ARM embedded stuff), but regardless..
> 
> Anyway, the pure size of that patch makes me suspect that we might as well 
> leave it until the next merge window, but if you do it and it's obviously 
> totally mechanical, I'd be likely to just let it slip in early.

I'll take a crack at it tomorrow - but if its 185 entries then it
probably wants to go into -next instead.

Alan
