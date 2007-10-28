Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbXJ1Xgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbXJ1Xgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbXJ1Xgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:36:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43153 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753667AbXJ1Xgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:36:40 -0400
Date: Sun, 28 Oct 2007 23:38:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028233826.24907fba@the-village.bc.nu>
In-Reply-To: <20071028225559.GD32359@parisc-linux.org>
References: <20071026170750.GC13033@fieldses.org>
	<20071026224707.GO13033@fieldses.org>
	<20071028173136.GA16905@fieldses.org>
	<20071028174321.GB16905@fieldses.org>
	<20071028182732.GK27248@parisc-linux.org>
	<20071028184052.49abd092@the-village.bc.nu>
	<20071028201101.GA32359@parisc-linux.org>
	<1193608230.7561.11.camel@heimdal.trondhjem.org>
	<20071028224157.GC32359@parisc-linux.org>
	<20071028224833.66dc4243@the-village.bc.nu>
	<20071028225559.GD32359@parisc-linux.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The spec and SYSV certainly ignore threading in this situation and you
> > know that perfectly well (or did in 2004)
> 
> The discussion petered out (or that mailing list archive lost articles
> from the thread) without any kind of resolution, or indeed interest.

I think the resolution was that the EDEADLK stayed.

> What is your suggestion for handling this problem?  As it is now, the
> kernel 'detects' deadlock where there is none, which doesn't seem
> allowed by SuSv3 either

Re-read the spec. The EDEADLK doesn't account for threads, only processes.

Alan
