Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbXI0Spz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbXI0Spz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXI0Spq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:45:46 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39054 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXI0Spq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:45:46 -0400
Date: Thu, 27 Sep 2007 12:45:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file without options
Message-ID: <20070927184543.GX3899@parisc-linux.org>
References: <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927183742.GA23734@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 02:37:42PM -0400, Theodore Tso wrote:
> I'm reminded of Rusty's 2003 OLS Keynote, where he points out that
> what's important is not making an interface easy to use, but _hard_
> _to_ _misuse_.  That fact that sysfs is all laid out in a directory,
> but for which some directories/symlinks are OK to use, and some are
> NOT OK to use --- is why I call the sysfs interface "an open pit".
> Sure, if you have the map to the minefield, a minefield is perfectly
> safe when you know what to avoid.  But is that the best way to
> construct a path/interface for an application programmer to get from
> point A to point B?  Maybe, maybe not.

I agree with your criticism of sysfs (indeed, I think I've made many of
them before in somewhat stronger language), but do you have a suggestion
as to an interface that would be harder to misuse?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
