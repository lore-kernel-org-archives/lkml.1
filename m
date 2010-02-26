Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966146Ab0BZUzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:55:48 -0500
Received: from www.tglx.de ([62.245.132.106]:38391 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966127Ab0BZUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:55:47 -0500
Date: Fri, 26 Feb 2010 21:54:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
In-Reply-To: <Pine.LNX.4.44L0.1002261435100.2029-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.1002262153050.4245@localhost.localdomain>
References: <Pine.LNX.4.44L0.1002261435100.2029-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Alan Stern wrote:
> On Thu, 4 Feb 2010, Thomas Gleixner wrote:
> 
> > On Thu, 4 Feb 2010, Greg KH wrote:
> > > > However in view of the other difficulties, it still doesn't seem
> > > > possible to make device mutexes work with lockdep.  I suggest removing 
> > > > Thomas's patch.
> > > 
> > > Unless Thomas or anyone else thinks of something that can solve these
> > > problems, I will do so.
> > 
> > Hmm, I have not seen those lockdep splats on -rt where we have the
> > mutex conversion for quite some time already. Need to look at it.
> 
> Thomas, did you ever figure out what was going on?  It would be nice to 
> know why the -rt kernels don't have any lockdep problems associated 
> with the device mutexes.

Yes, it just did not happen on the systems which I tested with lockdep
enabled, but I found a box where it triggered.

Sorry should have tested better. :(

Thanks,

	tglx
