Return-Path: <linux-kernel-owner+w=401wt.eu-S935550AbXKQBIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935550AbXKQBIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 20:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbXKQBIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 20:08:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:49210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbXKQBIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 20:08:21 -0500
Date: Fri, 16 Nov 2007 17:03:08 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.3
Message-ID: <20071117010308.GA13659@suse.de>
References: <20071116183752.GA9807@kroah.com> <20071116184430.GE9807@kroah.com> <473E247F.2090101@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473E247F.2090101@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 02:15:11AM +0300, Michael Tokarev wrote:
> Greg Kroah-Hartman wrote:
> > We (the -stable team) are announcing the release of the 2.6.23.3 kernel.
> > It contains a number of bugfixes for a number of architecture specific
> > issues.
> [.4, .5, .6 and .7 follows after .2 and .3]
> 
> I've seen the bunch of patches posted for review - split to several
> series.  But - out of curiocity - what's the reason to roll each
> series into each own stable release?  Can't all .2...7 be combined
> into a single release (not counting .8 wich contains urgent security
> fixes)?  (I mean, not with already rolled out stuff, but the original
> reasoning for split-releasing them (as opposed to split-reviewing))

Is there something "sacred" about version numbers that we need to be
stingy with them as they are a finite resource?  :)

This way, we have specific, easy to identify points in the development
process to help users in case they report problems to let the developers
easily narrow down the potential problem.

That, and I couldn't think of some other way to name the -rc patches, so
I used the minor version number.  Because of that, I was forced to name
the final releases with the same minor number to keep everyone sane over
time.

thanks,

greg k-h
