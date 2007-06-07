Return-Path: <linux-kernel-owner+w=401wt.eu-S937725AbXFGWfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937725AbXFGWfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937117AbXFGWe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:34:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35212 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S936489AbXFGWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:34:56 -0400
Date: Thu, 7 Jun 2007 23:39:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Gregor Jasny <gjasny@googlemail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070607233959.22d29e14@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	<9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	<466196AD.3090502@garzik.org>
	<9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
	<46667466.4010500@gmail.com>
	<9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
	<4667B347.9040900@gmail.com>
	<alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 13:56:11 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 7 Jun 2007, Tejun Heo wrote:
> >
> > Ah.. okay.  Now I see what's going on.  Jeff, this is another device
> > which doesn't set nsect and lbal to 1 after reset.  Gregor, please try
> > the attached patch.
> 
> Tejun, since Jeff is apparently traveling this week, and Gregor tested the 
> patch successfully (and it looks sane anyway - why in Gods name _would_ we 
> care what the initial setting of nsect/lbal is?), can you send this in 

Its a sanity check, and if the vendors could get their chips right a good
one, but specs/toilet paper  usual story

> with the changelog and sign-off?
> 
> Maybe it can go through Andrew like the other patch (the sata_promise 
> irq/polling handling), but I can take it directly too. Whatever seems 
> best.

I'll certainly ACK it, and it also means I can drop a pending patch to
handle the IT8212 raid mode which also gets this wrong.

Alan
