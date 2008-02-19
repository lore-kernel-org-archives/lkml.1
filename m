Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbYBSTKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbYBSTKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYBSTJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:09:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:59086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbYBSTJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:09:51 -0500
Date: Tue, 19 Feb 2008 11:07:45 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-ID: <20080219190745.GA4876@suse.de>
References: <20080213070215.GA11969@kroah.com> <20080212.230423.172781444.davem@davemloft.net> <1202887323.3129.10.camel@localhost> <20080213165924.GB10129@suse.de> <1202923995.3129.26.camel@localhost> <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:13:42AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 13 Feb 2008, Joe Perches wrote:
> > 
> > MAINTAINERS is the most frequently patched file
> 
> Almost all of them merge perfectly, with no problems what-so-ever. And the 
> merge conflicts, when they happen, are generally really trivial, and never 
> cause any subtle run-time bugs even if they were to happen.
> 
> So in that sense, I think both MAINTAINERS and the deprecation schedule 
> are totally uninteresting. Yes, they have merge conflicts. But those merge 
> conflicts are really really easy to handle.

Yes, they are easy to handle, but for trees that have to deal with these
merge issues all the time, they are a pain (hit this one again today.)
It takes a few minutes to fix up the resolution by hand (using either
git or quilt), as we do want the new addition to be in the file, so by
splitting it up, it makes our (the sub-tree maintainers) lives easier.

I've never had a problem with the MAINTAINERS file, as it is pretty big
and conflicts for me seem to never happen, but the feature-removal file
does cause problems as it changes over time and things need to get added
and removed.

Also, there are already remants of a bad-merge in that file, which
somehow sneaked through.

Yes, these files can not cause kernel bugs, but they are semi-important
to at least get correct.  So I'd ask you to reconsider for the
feature-removal stuff at the very least.

If you do, the git tree is still there at:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

to pull from :)

thanks,

greg k-h
