Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZGUQys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZGUQys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZGUQyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:54:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZGUQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:54:46 -0400
Date: Tue, 21 Jul 2009 09:51:53 -0700
From: Greg KH <greg@kroah.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sam Ramji <sramji@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       devel@driverdev.osuosl.org, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090721165153.GG14746@kroah.com>
References: <20090720160025.GA20249@kroah.com>
 <20090721110607.GA25127@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721110607.GA25127@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 04:36:07PM +0530, Balbir Singh wrote:
> * Greg Kroah-Hartman <gregkh@suse.de> [2009-07-20 09:00:25]:
> 
> > 
> > Hi all,
> > 
> > I'm happy to announce, that after many months of discussions, Microsoft
> > has released their Hyper-V Linux drivers under the GPLv2.  Following
> > this message, will be the patches that add the drivers to the
> > drivers/staging/ tree, and a whole bunch of cleanups.
> > 
> > It's taken a long road to get here, and I'd like to thank the following
> > people who made this possible:
> >   - Steve Hemminger for the initial prodding and extreme patience
> >   - Hank Janssen for providing the code and working with me to get it
> >     into a workable and semi-mergable state.  His involvement within
> >     Microsoft was also invaluable.
> >   - Sam Ramji for his push within Microsoft to make this happen in a
> >     manner that works with the Linux community.
> >   - Novell for sponsoring my work on the Linux Driver project, without
> >     which, this would not have even been possible.
> > And there are many others both within Novell and Microsoft, who I do not
> > want to slight by not naming, but the list would be too long to go into.
> > 
> > These drivers are to enable Linux to work better when running as a guest
> > on top of the Hyper-V system.  There is still a lot of work to do in
> > getting this into "proper" mergable state, and moving it out of the
> > staging directory, but Hank and I will be undertaking this task.  See
> > the TODO file in the drivers/staging/hv/ directory if anyone wishes to
> > help out with this task.
> >
> 
> What is the long term strategy to keep the sources in sync? Is there
> one? Do you expect to get updates for these sources? 

The in-kernel version will be the only source for the drivers in the
long run.  Eventually they will take the drivers off their web site when
the distros pick them up in their new releases.

thanks,

greg k-h
