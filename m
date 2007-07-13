Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXGMPKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXGMPKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936335AbXGMPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:10:29 -0400
Received: from [81.2.110.250] ([81.2.110.250]:34384 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S936283AbXGMPK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:10:27 -0400
Date: Fri, 13 Jul 2007 16:16:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Suleiman Souhlal <ssouhlal@freebsd.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
Message-ID: <20070713161612.2f2ebb0b@the-village.bc.nu>
In-Reply-To: <4693D9B6.4090408@ru.mvista.com>
References: <20070221011922.GA1777@freefall.freebsd.org>
	<200702210342.20775.bzolnier@gmail.com>
	<466EEFD6.9030001@ru.mvista.com>
	<200706160123.55636.bzolnier@gmail.com>
	<4693D9B6.4090408@ru.mvista.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> >>    BTW, why the timeout is so damn long? 2*WAIT_CMD is 20 secs, and if DMA is 
> >>not complete or interrupt pending, it may wait 10 more secs...
> 
> > I really don't remember... :)
> 
> > Maybe Mark or Alan could help with figuring this out.
> 
>     They also have probably forgotten. :-)

Because that value seemed to work ok. Mark set the timeouts way back in
history and I never touched most of them.

