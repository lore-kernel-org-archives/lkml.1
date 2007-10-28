Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXJ1Vsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXJ1Vsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXJ1Vsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:48:41 -0400
Received: from pat.uio.no ([129.240.10.15]:58934 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXJ1Vsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:48:40 -0400
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20071028201101.GA32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com>
	 <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org>
	 <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org>
	 <20071028174321.GB16905@fieldses.org>
	 <20071028182732.GK27248@parisc-linux.org>
	 <20071028184052.49abd092@the-village.bc.nu>
	 <20071028201101.GA32359@parisc-linux.org>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 17:50:30 -0400
Message-Id: <1193608230.7561.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.141)
X-UiO-Scanned: 7E39F2701A1130ABA457AC77BE1A1347AA43F2F1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 542 total 4766266 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-28 at 14:11 -0600, Matthew Wilcox wrote:
> On Sun, Oct 28, 2007 at 06:40:52PM +0000, Alan Cox wrote:
> > so we need to fix the bugs - the lock usage and the looping. At that
> > point it merely becomes a performance concern to those who use it, which
> > is the proper behaviour. If you want a faster non-checking one use
> > flock(), or add another flag that is a Linux "don't check for deadlock"
> 
> You can't fix the false EDEADLK detection without solving the halting
> problem.  Best of luck with that.

I can see that it would be difficult to do efficiently, but basically,
this boils down to finding a circular path in a graph. That is hardly an
unsolvable issue...

Trond

