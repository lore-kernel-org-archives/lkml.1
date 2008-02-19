Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYBSTfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYBSTfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYBSTfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:35:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42564 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbYBSTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:35:44 -0500
Date: Tue, 19 Feb 2008 11:34:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-Id: <20080219113422.ade12e7b.randy.dunlap@oracle.com>
In-Reply-To: <20080219190745.GA4876@suse.de>
References: <20080213070215.GA11969@kroah.com>
	<20080212.230423.172781444.davem@davemloft.net>
	<1202887323.3129.10.camel@localhost>
	<20080213165924.GB10129@suse.de>
	<1202923995.3129.26.camel@localhost>
	<alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org>
	<20080219190745.GA4876@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 11:07:45 -0800 Greg KH wrote:

> On Wed, Feb 13, 2008 at 10:13:42AM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 13 Feb 2008, Joe Perches wrote:
> > > 
> > > MAINTAINERS is the most frequently patched file
> > 
> > Almost all of them merge perfectly, with no problems what-so-ever. And the 
> > merge conflicts, when they happen, are generally really trivial, and never 
> > cause any subtle run-time bugs even if they were to happen.
> > 
> > So in that sense, I think both MAINTAINERS and the deprecation schedule 
> > are totally uninteresting. Yes, they have merge conflicts. But those merge 
> > conflicts are really really easy to handle.
> 
> Yes, they are easy to handle, but for trees that have to deal with these
> merge issues all the time, they are a pain (hit this one again today.)
> It takes a few minutes to fix up the resolution by hand (using either
> git or quilt), as we do want the new addition to be in the file, so by
> splitting it up, it makes our (the sub-tree maintainers) lives easier.
> 
> I've never had a problem with the MAINTAINERS file, as it is pretty big
> and conflicts for me seem to never happen, but the feature-removal file
> does cause problems as it changes over time and things need to get added
> and removed.
> 
> Also, there are already remants of a bad-merge in that file, which
> somehow sneaked through.
> 
> Yes, these files can not cause kernel bugs, but they are semi-important
> to at least get correct.  So I'd ask you to reconsider for the
> feature-removal stuff at the very least.
> 
> If you do, the git tree is still there at:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/
> 
> to pull from :)

Alternatively, since they are easy to fix, I'll volunteer to fix them
(after notified of problems :).  (and not split up the file)

---
~Randy
