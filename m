Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZGTQDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZGTQDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZGTQDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:03:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZGTQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:03:48 -0400
Date: Mon, 20 Jul 2009 09:00:25 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       virtualization@lists.osdl.org
Cc: Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720160025.GA20249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I'm happy to announce, that after many months of discussions, Microsoft
has released their Hyper-V Linux drivers under the GPLv2.  Following
this message, will be the patches that add the drivers to the
drivers/staging/ tree, and a whole bunch of cleanups.

It's taken a long road to get here, and I'd like to thank the following
people who made this possible:
  - Steve Hemminger for the initial prodding and extreme patience
  - Hank Janssen for providing the code and working with me to get it
    into a workable and semi-mergable state.  His involvement within
    Microsoft was also invaluable.
  - Sam Ramji for his push within Microsoft to make this happen in a
    manner that works with the Linux community.
  - Novell for sponsoring my work on the Linux Driver project, without
    which, this would not have even been possible.
And there are many others both within Novell and Microsoft, who I do not
want to slight by not naming, but the list would be too long to go into.

These drivers are to enable Linux to work better when running as a guest
on top of the Hyper-V system.  There is still a lot of work to do in
getting this into "proper" mergable state, and moving it out of the
staging directory, but Hank and I will be undertaking this task.  See
the TODO file in the drivers/staging/hv/ directory if anyone wishes to
help out with this task.

The code should be showing up in the linux-next tree soon, as the
patches are now in my public tree.

If anyone has any questions about this code, please let me and Hank know
about it.

thanks,

greg k-h
