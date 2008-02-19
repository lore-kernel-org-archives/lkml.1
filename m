Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbYBSUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbYBSUHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYBSUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:07:23 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58233 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYBSUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:07:22 -0500
Date: Tue, 19 Feb 2008 22:06:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-ID: <20080219200646.GK31955@cs181133002.pp.htv.fi>
References: <20080213070215.GA11969@kroah.com> <20080212.230423.172781444.davem@davemloft.net> <1202887323.3129.10.camel@localhost> <20080213165924.GB10129@suse.de> <1202923995.3129.26.camel@localhost> <alpine.LFD.1.00.0802131012040.2920@woody.linux-foundation.org> <20080219190745.GA4876@suse.de> <20080219113422.ade12e7b.randy.dunlap@oracle.com> <20080219194909.GA17802@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080219194909.GA17802@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 11:49:10AM -0800, Greg KH wrote:
> On Tue, Feb 19, 2008 at 11:34:22AM -0800, Randy Dunlap wrote:
> > On Tue, 19 Feb 2008 11:07:45 -0800 Greg KH wrote:
> > 
> > > On Wed, Feb 13, 2008 at 10:13:42AM -0800, Linus Torvalds wrote:
> > > > 
> > > > 
> > > > On Wed, 13 Feb 2008, Joe Perches wrote:
> > > > > 
> > > > > MAINTAINERS is the most frequently patched file
> > > > 
> > > > Almost all of them merge perfectly, with no problems what-so-ever. And the 
> > > > merge conflicts, when they happen, are generally really trivial, and never 
> > > > cause any subtle run-time bugs even if they were to happen.
> > > > 
> > > > So in that sense, I think both MAINTAINERS and the deprecation schedule 
> > > > are totally uninteresting. Yes, they have merge conflicts. But those merge 
> > > > conflicts are really really easy to handle.
> > > 
> > > Yes, they are easy to handle, but for trees that have to deal with these
> > > merge issues all the time, they are a pain (hit this one again today.)
> > > It takes a few minutes to fix up the resolution by hand (using either
> > > git or quilt), as we do want the new addition to be in the file, so by
> > > splitting it up, it makes our (the sub-tree maintainers) lives easier.
> > > 
> > > I've never had a problem with the MAINTAINERS file, as it is pretty big
> > > and conflicts for me seem to never happen, but the feature-removal file
> > > does cause problems as it changes over time and things need to get added
> > > and removed.
> > > 
> > > Also, there are already remants of a bad-merge in that file, which
> > > somehow sneaked through.
> > > 
> > > Yes, these files can not cause kernel bugs, but they are semi-important
> > > to at least get correct.  So I'd ask you to reconsider for the
> > > feature-removal stuff at the very least.
> > > 
> > > If you do, the git tree is still there at:
> > > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/
> > > 
> > > to pull from :)
> > 
> > Alternatively, since they are easy to fix, I'll volunteer to fix them
> > (after notified of problems :).  (and not split up the file)
> 
> Well, the problem is that when someone sends me a patch, I have to do
> the fixups by hand (same goes for Jeff), in order for you, or anyone
> else to even be able to see the patch show up anywhere.
> 
> That's why having this split up will help make the sub-tree maintainers
> lives easier, it's not an issue for Andrew and Linus, as usually the
> problem is all fixed up by the time the patch makes it there :)

I'm not sure whether it's feasible, but there's a tricky alternative 
solution:
Adding or removing entries must not add or remove any empty or dash lines.

With this rule, all other entries would be outside of the context of
patches touching feature-removal-schedule.txt...

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

