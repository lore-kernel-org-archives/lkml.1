Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbXJ1XnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbXJ1XnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXJ1XnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:43:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52559 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753312AbXJ1XnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:43:03 -0400
Date: Sun, 28 Oct 2007 23:44:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028234457.0011d8b7@the-village.bc.nu>
In-Reply-To: <20071028233814.GF32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com>
	<20071018185759.GU3785@mvista.com>
	<20071026170750.GC13033@fieldses.org>
	<20071026224707.GO13033@fieldses.org>
	<20071028173136.GA16905@fieldses.org>
	<20071028174321.GB16905@fieldses.org>
	<20071028182732.GK27248@parisc-linux.org>
	<20071028184052.49abd092@the-village.bc.nu>
	<20071028201101.GA32359@parisc-linux.org>
	<20071028213855.769741b6@the-village.bc.nu>
	<20071028233814.GF32359@parisc-linux.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 17:38:14 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sun, Oct 28, 2007 at 09:38:55PM +0000, Alan Cox wrote:
> > > It doesn't require the system to detect it, only mandate what to return
> > > if it does detect it.
> > 
> > We should be detecting at least the obvious case.
> 
> What is the obvious case?  A task that has never called clone()?

Simple AB BA I would have thought obvious. Clone as has been said several
times now is irrelevant as the standard is about *processes* [in the SuS
sense]
