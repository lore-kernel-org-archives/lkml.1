Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYIXXEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYIXXEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYIXXE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:04:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYIXXE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:04:27 -0400
Date: Wed, 24 Sep 2008 16:00:54 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       Jeff Mahoney <jeffm@suse.de>
Subject: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-ID: <20080924230054.GA27730@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we all discussed at the Kernel Summit this past week, I said I would
create a drivers/staging directory and start throwing lots of drivers
that are not of "mergable" status into it.

For those not at the kernel summit, lwn.net has a summary of this
session at:
	http://www.lwn.net/Articles/298570/

So, here's 4 patches for review/comments that show how this could be
done.

The first 2 patches create a TAINT_CRAP flag and set it for anything
that comes from the drivers/staging/ directory.  When a driver from this
directory is loaded into the kernel, the user is warned, and any oops
message that happens also properly shows the "bad" modules.

The 3rd patch creates the drivers/staging/ directory and Kconfig entries
and adds it to the build system.

The 4th patch is an example of a driver that would go into this
directory, along with a driver_name.README file detailing what needs to
be done to this driver for cleanup/fixing, and who to contact about it.
It's also in such bad shape it doesn't even build against the kernel
kernel :)

(I'll fix that up before submitting, all drivers should at least build
properly...)

So, does this all look good to everyone?  Any questions/issues?

Oh, I guess I should add a MAINTAINER entry for this section of the
kernel, so to paraphrase Linus, I now get to be known as the "Maintainer
of Crap".

thanks,

greg k-h
