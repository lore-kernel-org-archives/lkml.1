Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0AOPr2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 10:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851Ab0AOPr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 10:47:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0AOPr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:47:27 -0500
Date: Fri, 15 Jan 2010 16:41:31 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/15] Staging: Convert the semaphore mess
In-Reply-To: <20100115151942.GA10117@suse.de>
Message-ID: <alpine.LFD.2.00.1001151640030.5514@localhost.localdomain>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com> <20100115012921.GE32278@kroah.com> <alpine.LFD.2.00.1001151607570.5514@localhost.localdomain> <20100115151942.GA10117@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jan 2010, Greg KH wrote:

> On Fri, Jan 15, 2010 at 04:11:23PM +0100, John Kacur wrote:
> > 
> > 
> > On Thu, 14 Jan 2010, Greg KH wrote:
> > 
> > > On Mon, Jan 11, 2010 at 09:51:39PM +0100, John Kacur wrote:
> > > > Thomas / Ingo / Greg
> > > > 
> > > > I started with the patch in -rt 041e3130496f31d0cb4887fc6183117e662f5141
> > > > and tried to forward port it to 2.6.33-rc3
> > > > 
> > > > The patch no-longer applied, because some of the changes were already accepted
> > > > upstream, some files had been moved or dropped and so on.
> > > > 
> > > > So, I broke the original patch into one patch per file, and fixed merge errors.
> > > > Then I also went and changed similar problems in new code
> > > > 
> > > > This code should be queued-up for the 2.6.34 merge window, and should also
> > > > be applied to the latests -rt branch.
> > > 
> > > I can't do that, as it breaks when applying to Linus's latest tree,
> > > right?
> > > 
> > > If this needs to go through some other tree, no objection from me at
> > > all, feel free to add:
> > > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > to them.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Hi Greg.
> > 
> > This shouldn't break - I tested against 2.6.33-rc3, and I just retested 
> > against 2.6.33-rc4. The origin of the patch is in -rt but there is nothing
> > -rt about it which is why I would like to push it upstream.
> > 
> > I don't have all that hardware, so my ability to test it is somewhat 
> > limited - and since these are all staging drivers, I was hoping that you 
> > would pick it up if Thomas doesn't have any objections.
> 
> Try applying your first patch against 2.6.33-rc3 and then just building
> the code.  It dies a horrible death :)
> 

Ugh! You're right Greg. These patches are pending Thomas's "Introduce 
anon_semaphore" going upstream first.

I'll wait for that before pushing these again.

Thanks.

