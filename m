Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXJ1WtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXJ1WtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXJ1Ws4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:48:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54651 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189AbXJ1Wsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:48:55 -0400
Date: Sun, 28 Oct 2007 22:48:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028224833.66dc4243@the-village.bc.nu>
In-Reply-To: <20071028224157.GC32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com>
	<20071018185759.GU3785@mvista.com>
	<20071026170750.GC13033@fieldses.org>
	<20071026224707.GO13033@fieldses.org>
	<20071028173136.GA16905@fieldses.org>
	<20071028174321.GB16905@fieldses.org>
	<20071028182732.GK27248@parisc-linux.org>
	<20071028184052.49abd092@the-village.bc.nu>
	<20071028201101.GA32359@parisc-linux.org>
	<1193608230.7561.11.camel@heimdal.trondhjem.org>
	<20071028224157.GC32359@parisc-linux.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Bzzt.  You get a false deadlock with multiple threads like so:
> 
> Thread A of task B takes lock 1
> Thread C of task D takes lock 2
> Thread C of task D blocks on lock 1
> Thread E of task B blocks on lock 2

The spec and SYSV certainly ignore threading in this situation and you
know that perfectly well (or did in 2004)
