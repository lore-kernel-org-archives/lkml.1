Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbXCOT3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbXCOT3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXCOT3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:29:31 -0400
Received: from pat.uio.no ([129.240.10.15]:50922 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904AbXCOT3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:29:30 -0400
Subject: Re: Three critical patches still aren't merged in 2.6.21
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-stable <stable@kernel.org>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070315112532.7d6a6521.akpm@linux-foundation.org>
References: <45F9757F.2020900@redhat.com>
	 <20070315112532.7d6a6521.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 15:29:19 -0400
Message-Id: <1173986959.6506.86.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: C507C4BC9F5EC9C7688DF06A622B98BC2D5D5EBB
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 422 total 505535 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 11:25 -0800, Andrew Morton wrote:
> On Thu, 15 Mar 2007 12:34:07 -0400 Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > I've been holding off sending these in for -stable until they're
> > merged, but now I wonder when that will happen.
> 
> We'll get there.  I just got off the plane.
> 
> > http://lkml.org/lkml/2007/3/14/99
> > [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
> > From: Thomas Gleixner <tglx@linutronix,de> 
> > 
> > http://lkml.org/lkml/2007/3/12/268
> > NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > 
> > http://lkml.org/lkml/2007/3/12/60
> > [patch] futex: PI state locking fix
> > From: Ingo Molnar <mingo@elte.hu>
> 
> I have all three in various stages of queuedness, but I am presently
> expecting Trond to merge the NFS one.  I can send it if he wants?

Please do, and if you could also send in Peter Zijlstra's congestion
control patch at the same time, then that would be great. The latter is
partly a VM patch, so Linus will bit^H^H^Hcomplain if I send it as part
of a git merge...

Cheers,
  Trond

