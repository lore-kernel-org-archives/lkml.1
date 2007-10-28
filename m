Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXJ1W4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXJ1W4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXJ1W4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:56:03 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38615 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbXJ1W4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:56:01 -0400
Date: Sun, 28 Oct 2007 16:55:59 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028225559.GD32359@parisc-linux.org>
References: <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org> <20071028173136.GA16905@fieldses.org> <20071028174321.GB16905@fieldses.org> <20071028182732.GK27248@parisc-linux.org> <20071028184052.49abd092@the-village.bc.nu> <20071028201101.GA32359@parisc-linux.org> <1193608230.7561.11.camel@heimdal.trondhjem.org> <20071028224157.GC32359@parisc-linux.org> <20071028224833.66dc4243@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028224833.66dc4243@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 10:48:33PM +0000, Alan Cox wrote:
> > Bzzt.  You get a false deadlock with multiple threads like so:
> > 
> > Thread A of task B takes lock 1
> > Thread C of task D takes lock 2
> > Thread C of task D blocks on lock 1
> > Thread E of task B blocks on lock 2
> 
> The spec and SYSV certainly ignore threading in this situation and you
> know that perfectly well (or did in 2004)

The discussion petered out (or that mailing list archive lost articles
from the thread) without any kind of resolution, or indeed interest.
What is your suggestion for handling this problem?  As it is now, the
kernel 'detects' deadlock where there is none, which doesn't seem
allowed by SuSv3 either.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
