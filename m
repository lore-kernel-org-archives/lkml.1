Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXJ2IG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXJ2IG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXJ2IGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:06:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39691 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751261AbXJ2IGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:06:38 -0400
Date: Mon, 29 Oct 2007 08:08:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071029080822.6f04194c@the-village.bc.nu>
In-Reply-To: <20071029022922.GD10307@fieldses.org>
References: <20071028173136.GA16905@fieldses.org>
	<20071028174321.GB16905@fieldses.org>
	<20071028182732.GK27248@parisc-linux.org>
	<20071028184052.49abd092@the-village.bc.nu>
	<20071028201101.GA32359@parisc-linux.org>
	<1193608230.7561.11.camel@heimdal.trondhjem.org>
	<20071028224157.GC32359@parisc-linux.org>
	<20071028224833.66dc4243@the-village.bc.nu>
	<20071028225559.GD32359@parisc-linux.org>
	<20071028233826.24907fba@the-village.bc.nu>
	<20071029022922.GD10307@fieldses.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And if posix file locks are to be useful to threaded applications, then
> we have to preserve the same no-false-positives requirement for them as
> well.

It isn't useful to threaded applications. The specification requires
this. Which is another reason for having an additional Linux (for now)
flag to say "don't bother"

Alan
