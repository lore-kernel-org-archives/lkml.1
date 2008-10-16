Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYJPA2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYJPA2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYJPA23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:28:29 -0400
Received: from kroah.org ([198.145.64.141]:37338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752269AbYJPA22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:28:28 -0400
Date: Wed, 15 Oct 2008 17:25:09 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] Kernel version numbering scheme change
Message-ID: <20081016002509.GA25868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You brought this topic up a few months ago, and passed it off as
something we would discuss at the kernel summit.  But that never
happened, so I figured I'd bring it up again here.

So, as someone who constantly is dealing with kernel version numbers all
the time with the -stable trees, our current numbering scheme is a pain
a times.  How about this proposal instead?

We number the kernel based on the year, and the numbers of releases we
have done this year:
	YEAR.NUMBER.MINOR_RELEASE

For example, the first release in 2009 would be called:
	2009.0.0
The second:
	2009.1.0

If we want to be a bit more "non-zero-counting" friendly: we can start
at "1" for the number:
	2009.1.0 for the first release
	2009.2.0 for the second.

Then the stable releases can increment the minor number:
	2009.1.1 for the first stable release
	2009.1.2 for the second.
	and so on.

Benefits of this is it more accuratly represents to people just how old
the kernel they are currently running is (2.6.9 would be have been
2004.9.0 on this naming scheme.)

Yes, we can handle the major/minor macros in the kernel to provide a
compatible number so that automated scripts will not break, that's not a
big deal.

Any thoughts?

Let the bike-shedding begin!

thanks,

greg k-h
