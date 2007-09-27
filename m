Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbXI0SiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbXI0SiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXI0Sh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:37:59 -0400
Received: from THUNK.ORG ([69.25.196.29]:55967 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbXI0Sh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:37:58 -0400
Date: Thu, 27 Sep 2007 14:37:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file without options
Message-ID: <20070927183742.GA23734@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jens Axboe <jens.axboe@oracle.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070927142919.10b62f9b@the-village.bc.nu> <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927175917.GB8339@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 10:59:17AM -0700, Greg KH wrote:
> Come on now, I'm _very_ tired of this kind of discussion.  Please go
> read the documentation on how to _use_ sysfs from userspace in such a
> way that you can properly access these data structures so that no
> breakage occurs.

I've read it; the question is whether every single application
programmer or system shell script programmer who writes code my system
depends upon has read it this document buried in the kernel sources,
or whether things will break spectacularly --- one of those things
that leaves me in suspense each time I update the kernel.

I'm reminded of Rusty's 2003 OLS Keynote, where he points out that
what's important is not making an interface easy to use, but _hard_
_to_ _misuse_.  That fact that sysfs is all laid out in a directory,
but for which some directories/symlinks are OK to use, and some are
NOT OK to use --- is why I call the sysfs interface "an open pit".
Sure, if you have the map to the minefield, a minefield is perfectly
safe when you know what to avoid.  But is that the best way to
construct a path/interface for an application programmer to get from
point A to point B?  Maybe, maybe not.

					- Ted
