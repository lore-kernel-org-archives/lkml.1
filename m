Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYJ3F43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYJ3F43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYJ3F4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:56:18 -0400
Received: from kroah.org ([198.145.64.141]:59353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532AbYJ3F4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:56:18 -0400
Date: Wed, 29 Oct 2008 22:49:44 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: merging other repos into linux-2.6
Message-ID: <20081030054944.GA19035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In working with some of the current out-of-tree drivers, some of them
are asking if they could keep their past development history when
merging the code into the main kernel tree.

Now normally we don't do this for new drivers, just dropping them in in
one big patch, or sometimes multiple patches to get it through email
filters.

The comedi group (data acquisition subsystem for Linux) have their whole
history going back to 2000 in a git tree (well, a cvs->git repo.)

I was wondering if it would be acceptable to graft their tree into the
linux-2.6 tree (after moving the files to the proper location) to keep
their whole old history alive.

Now what good that old history would do, I really don't know and can't
think of a solid reason to need it, other than to give proper authorship
credit for the various individual drivers and parts of the code (which
is good to have at tims.)

But the merge looks pretty cool, and it is impressive that git can allow
this to happen, so there are some extra "style" points a merge like this
would give :)

So, any thoughts?  Should I graft the trees, or just stick to simple
"here's the whole driver" type patches like we have been doing?

thanks,

greg k-h
