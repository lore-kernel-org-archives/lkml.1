Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbXHIWf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbXHIWf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXHIWfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:35:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60670 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbXHIWfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:35:21 -0400
Date: Thu, 9 Aug 2007 23:42:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>,
       "Kristofer T. Karas" <ktk@enterprise.bidmc.harvard.edu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.23-rc2-mm1
Message-ID: <20070809234215.212ac954@the-village.bc.nu>
In-Reply-To: <20070809150454.42eea7c5.akpm@linux-foundation.org>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
	<46BB88C4.5010107@googlemail.com>
	<20070809150454.42eea7c5.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > [   28.828484] 0000:00:1f.1: cannot adjust BAR0 (not I/O)
> > [   28.828487] 0000:00:1f.1: cannot adjust BAR1 (not I/O)
> > [   28.828489] 0000:00:1f.1: cannot adjust BAR2 (not I/O)
> > [   28.828491] 0000:00:1f.1: cannot adjust BAR3 (not I/O)

This means it didn't do anything. (wrongly because its checking I/O bits
on a BAR which are ignored according to the spec)

> >         Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
> >         Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
> >         Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
> >         Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]

The controller is disabled and when disabled it seems to think its
memory. Valid but interesting.

