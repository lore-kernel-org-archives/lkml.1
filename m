Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0BEEG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 23:06:57 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45328 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751150Ab0BEEG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 23:06:56 -0500
Date: Thu, 4 Feb 2010 23:06:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Cong Wang <amwang@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
In-Reply-To: <4B6B8BD5.8020404@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1002042306180.11360-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Cong Wang wrote:

> Alan Stern wrote:
> > On Thu, 4 Feb 2010, Peter Zijlstra wrote:
> > 
> >> On Thu, 2010-02-04 at 11:35 -0500, Alan Stern wrote:
> >>> +#include <linux/sched.h>
> >> #include <linux/lockdep.h>
> >>
> >> should be sufficient I think.
> > 
> > No, it's not.  It leaves MAX_LOCK_DEPTH undeclared.  Beats me why that 
> > symbol ended up in sched.h...
> > 
> 
> because task_struct->held_locks uses it, but it seems better to move
> it into lockdep.h...

Be my guest!  :-)

Alan Stern

