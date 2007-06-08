Return-Path: <linux-kernel-owner+w=401wt.eu-S969148AbXFHPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969148AbXFHPdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763388AbXFHPc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:32:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40150 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756645AbXFHPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:32:55 -0400
Date: Fri, 8 Jun 2007 16:38:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070608163804.4926e499@the-village.bc.nu>
In-Reply-To: <20070608143136.GC25649@havoc.gtf.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	<9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	<466196AD.3090502@garzik.org>
	<9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
	<46667466.4010500@gmail.com>
	<9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
	<4667B347.9040900@gmail.com>
	<alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
	<20070607224746.GA23290@havoc.gtf.org>
	<46690D10.9040808@gmail.com>
	<20070608143136.GC25649@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> See a URL I posted earlier in this thread.  With dumb ATAPI devices we
> actually have to wait a bit for BSY to be asserted.  Not only at reset,
> but also for every command

400nS and the current code correctly accounts for it.

> > How about limiting nsect/lbal wait duration?  Say, 100ms or 500ms?  That
> > can somewhat ease our paranoia and should show acceptable behavior for
> > braindead devices too.
> 
> That's quite reasonable.

Agreed - means the IT821x takes a bit longer to respond but ensures that
we avoid any unpleasant suprises elsewhere.
