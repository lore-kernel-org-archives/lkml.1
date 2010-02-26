Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965891Ab0BZTgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:36:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35660 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965854Ab0BZTgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:36:33 -0500
Date: Fri, 26 Feb 2010 14:36:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
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
In-Reply-To: <alpine.LFD.2.00.1002041758310.3006@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.1002261435100.2029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Thomas Gleixner wrote:

> On Thu, 4 Feb 2010, Greg KH wrote:
> > > However in view of the other difficulties, it still doesn't seem
> > > possible to make device mutexes work with lockdep.  I suggest removing 
> > > Thomas's patch.
> > 
> > Unless Thomas or anyone else thinks of something that can solve these
> > problems, I will do so.
> 
> Hmm, I have not seen those lockdep splats on -rt where we have the
> mutex conversion for quite some time already. Need to look at it.

Thomas, did you ever figure out what was going on?  It would be nice to 
know why the -rt kernels don't have any lockdep problems associated 
with the device mutexes.

Alan Stern

