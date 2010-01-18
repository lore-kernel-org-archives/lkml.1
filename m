Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022Ab0ARTMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0ARTMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264Ab0ARTMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:12:46 -0500
Received: from kroah.org ([198.145.64.141]:47554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0ARTMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:12:46 -0500
Date: Mon, 18 Jan 2010 11:09:39 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: Stable kernel tree status, January 18, 2010
Message-ID: <20100118190939.GA26189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the state of the -stable kernel trees, as of January 18, 2010.

2.6.27-stable

The 2.6.27-stable kernel tree is still living on, as a "long-term"
stable release.  But, I do have to warn users of this tree, the older it
gets, the less viable it becomes.  Not all bugfixes are being backported
to this kernel version due to massive code changes in the over 2 years
since this kernel has been released.  I am doing my best to backport
fixes that I become aware of, and I encourage anyone who does fix any
types of bugs in the main kernel tree to let me know if the change
should be applied to this older kernel version.

I'll probably keep maintaining it for at least 6-8 more months, but
after that, I can not guarantee it's viability.  Note, one other
developer has volunteered to pick up the tree after I am finished with
it, but I can not speak for him at this time.


2.6.31-stable

Today the last 2.6.31-stable kernel was released, all users of this
kernel series are strongly encouraged to switch to the 2.6.32 kernel
series, as there will not be any more updates for this branch in the
future.


2.6.32-stable

I'd like to announce that the 2.6.32-stable tree is also going to be
maintained as a "long-term" stable release, living for 2-3 years, like
the 2.6.27 kernel is.  This is because a number (i.e. more than 2) Linux
distributions are basing their "enterprise" releases on this kernel
version, and it will make their lives easier if I keep it alive.

Note, the viability of me keeping this tree alive for such a length of
time relies on the developers working for those distros to keep me
informed of patches that need to be backported and applied to it.
Without their help, I will have no problem in stopping the maintenance
of the tree.


Submitting patches for stable trees

Again, the easiest way to get your patch into a -stable tree is to
merely add the line:
	Cc: stable <stable@kernel.org>
to the Signed-off-by: area of your patch.  When the patch goes into
Linus's tree, it will be automatically sent to the stable address, and I
will know to apply it to the trees.  If I have any problem applying it
at that time, I will email the author and reviewers of the patch about
it.

If you forgot to add this line to the patch, or you have found a patch
written by someone else that you wish to have applied to the stable
trees, email the git commit id of the patch as it shows up in Linus's
tree to the stable@kernel.org email address.  Any stable correspondence
sent to my personal accounts has the chance of being lost in the
shuffle, so please try to not do that.

If a patch needs to be backported to one of the stable trees because it
does not apply directly, please send the backported patch, along with
the git commit id of the original patch, to the stable@kernel.org
address, with a description of which kernel tree it should be applied
to.


If anyone has any other questions about stable releases, please let me
know.

thanks,

greg k-h
