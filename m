Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0BDSkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:40:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57655 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757305Ab0BDSkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:40:15 -0500
Date: Thu, 4 Feb 2010 13:40:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
In-Reply-To: <1265301965.22001.133.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.1002041337590.1261-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Peter Zijlstra wrote:

> On Thu, 2010-02-04 at 11:35 -0500, Alan Stern wrote:
> > +#include <linux/sched.h>
> 
> #include <linux/lockdep.h>
> 
> should be sufficient I think.

No, it's not.  It leaves MAX_LOCK_DEPTH undeclared.  Beats me why that 
symbol ended up in sched.h...

Alan Stern

