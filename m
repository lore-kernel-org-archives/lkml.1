Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbYH0W1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbYH0W1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYH0W1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:27:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44628 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751296AbYH0W1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:27:15 -0400
Date: Wed, 27 Aug 2008 23:08:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Osterlund <petero2@telia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080827230828.4285022b@lxorguk.ukuu.org.uk>
In-Reply-To: <m3k5e2qkk2.fsf@telia.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	<alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org>
	<m3k5e2qkk2.fsf@telia.com>
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

> >
> > We need to fix this.
> 
> Why not just revert the offending change and try again during the next
> merge window, assuming someone has figured out an acceptable way to
> handle this mess by then?

Easier just to fix it. Its a case of building everything until it
compiles with the prototype change. Almost all stuff  will just take the
argument initially and not use it.

Anyone else plan to do it or shall I hit all the x86 cases and post a
patch ?

