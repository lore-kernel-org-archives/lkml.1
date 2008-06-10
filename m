Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYFJUND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYFJUND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYFJUMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:12:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:39751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbYFJUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:12:48 -0400
X-Greylist: delayed 3905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 16:12:47 EDT
Date: Tue, 10 Jun 2008 12:05:40 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [ANNOUNCE] linux-staging tree created
Message-ID: <20080610190540.GA25066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh great, not yet-another-kernel-tree, just what the world needs...

Yes, this is an announcement of a new kernel tree, linux-staging.  It is
a quilt series of patches that can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git


In a long and meandering thread with some of the other kernel developers
a week or so ago, it came up that there is no single place for companies
and developers to put their code for testing while it gets cleaned up
for submission into the kernel tree.  All of the different subsystems
have trees, but they generally only want code that is about to go into
this release, or the next one.  For stuff that is farther off, there is
no place to go.

So, here's the tree for it.  From the README:

PURPOSE

The linux-staging tree was created to hold drivers and filesystems and
other semi-major additions to the Linux kernel that are not ready to be
merged at this point in time.  It is here for companies and authors to
get a wider range of testing, and to allow for other members of the
community to help with the development of these features for the
eventual inclusion into the main kernel tree.

This tree will be included in the daily linux-next builds, and will get
testing by all users of that tree.

The rules of what can be included here is as follows:
	- the code must be released under a Linux kernel-compatible
	  license
	- the goal of the developers must be to merge this code into the
	  main kernel tree in the near future, but not for the next
	  kernel release.
	- the code must build properly on the x86 platform
	- this is not a tree for bugfixes or rewrites of existing kernel
	  code, this should be for new features, drivers, and
	  filesystems.
	- the patches included must detail exactly what is needed to be
	  completed in order for them to be included into the main
	  kernel tree.
	- there must be some email address associated with the patch
	  that can be used for bug reporting and questions about
	  cleanups and testing the code.

What this tree is not:
	- it is not a place to dump features that are being actively
	  developed by a community of people (reiserfs4 for example.)
	- it is not a place to dump code and then run away, hoping that
	  someone else will do the cleanup work for you.  While there
	  are developers available to do this kind of work, you need to
	  get someone to agree to "babysit" the code.


I'll follow up this message with a list of the current status of the
individual patches and what is currently contained in the tree.  I hope
to release a status like this every week or so, depending on how the
development goes.

What I need from all of you:
  Kernel Janitors:
  	Here is the perfect way to get involved.  The code in this tree
	is in desparate need of cleanups and fixes that can be trivially
	found using 'sparse' and 'scripts/checkpatch.pl'.  I'll gladly
	take these kinds of patches and of course, correctly credit you.

  Linux driver project developers:
	Same as above, here's a great place to start out helping with
	real code.  If any of you wants to take any of these drivers
	over and become the primary contact point for them, just let me
	know.

  Linux-next developers:
	Stephen, I would really like this tree to be included in -next.
	Yes, I know it contains things that will not be included in the
	next release, but the inclusion and basic build testing that is
	provided by your tree is invaluable.  You can place it at the
	end, and if there is even a whiff of a problem in any of the
	patches, you have my full permission to drop them on the floor
	and run away screaming (and let me know please, so I can fix it
	up.)

  Linux kernel developers:
	If there are any external patches floating around for drivers
	that need to be cleaned up and gotten into the kernel tree,
	please point them out to me and I'll be glad to add them to this
	tree and work to get them included.  Right now we are pushing:
	 - 192 files changed, 131073 insertions(+), 651 deletions(-)
	so what's a few more thousand lines of code :)

Any questions?  Comments?

thanks,

greg k-h
