Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0BDRGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:06:04 -0500
Received: from www.tglx.de ([62.245.132.106]:52213 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0BDRGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:06:01 -0500
Date: Thu, 4 Feb 2010 17:59:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
In-Reply-To: <20100204164608.GA17825@suse.de>
Message-ID: <alpine.LFD.2.00.1002041758310.3006@localhost.localdomain>
References: <1265283496.24455.1939.camel@laptop> <Pine.LNX.4.44L0.1002041027070.2470-100000@iolanthe.rowland.org> <20100204164608.GA17825@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Greg KH wrote:
> > However in view of the other difficulties, it still doesn't seem
> > possible to make device mutexes work with lockdep.  I suggest removing 
> > Thomas's patch.
> 
> Unless Thomas or anyone else thinks of something that can solve these
> problems, I will do so.

Hmm, I have not seen those lockdep splats on -rt where we have the
mutex conversion for quite some time already. Need to look at it.

Thanks,

	tglx
