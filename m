Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYEHEhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYEHEhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYEHEhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:37:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56199 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYEHEhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:37:22 -0400
Date: Wed, 7 May 2008 21:27:53 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: the purge :-)
Message-ID: <20080508042753.GA6876@kroah.com>
References: <20080508112130.fd574b50.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508112130.fd574b50.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 11:21:30AM +1000, Stephen Rothwell wrote:
> Greg, you might consider setting up a subset (currently probably
> empty) of the ldp tree for drivers that are readier for integration.

Ok, fair enough, I totally understand.

I've now moved my trees around a bit, and would like it if you could
include the following, in this order (the # NEXT_BASE variable is set in
them to make sure things get ordered properly.)
	driver-core.next
	usb.next
	driver-core
	usb
	ldp.next

The ".next" trees are what is going to Linus before the next major
release happens (bugfixes and new device ids at this point in time for
example.)  The other trees are what is going to go to Linus after the
next major kernel is out.

I also have a "ldp" tree as well, but I understand why you do not want
to pull it at this time into linux-next.

And, there is a real driver already in the ldp.next tree that should
show up in 2.6.27, so it isn't empty at this time :)

If you have any questions about these trees, please let me know.

thanks,

greg k-h
