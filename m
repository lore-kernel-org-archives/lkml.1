Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbXIZUR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbXIZUR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXIZURT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:17:19 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:43610 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXIZURT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:17:19 -0400
Date: Wed, 26 Sep 2007 23:17:17 +0300 (EEST)
From: Timo Jantunen <jeti@welho.com>
To: Willy Tarreau <w@1wt.eu>
cc: Francois Romieu <romieu@fr.zoreil.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 kills r8169 send
 performance
In-Reply-To: <20070926200307.GL10199@1wt.eu>
Message-ID: <Pine.LNX.4.64.0709262313090.5856@limbo>
References: <Pine.LNX.4.64.0709261853110.5869@limbo>
 <20070926170718.GA4870@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0709262137440.5856@limbo>
 <20070926200307.GL10199@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007, Willy Tarreau wrote:

> On Wed, Sep 26, 2007 at 09:52:02PM +0300, Timo Jantunen wrote:
> > On Wed, 26 Sep 2007, Francois Romieu wrote:
> > > The patch below is scheduled for inclusion before 2.6.23. Please try it and
> > > see if it makes a difference on top of 2.6.23-rc8 (full dmesg will be welcome
> > > too).
> > Thanks for the quick reply and fix. Unfortunately the fix didn't help in my 
> > case.
> 
> In another thread on LKML today, there has been some discussion about a
> similar problem, which is caused by a locking bug in iperf which makes
> it spin at 100% CPU. Ingo has posted a fix for this, please check the list.

I noticed the problem originally with another program (playback of 720p 
video to remote X using mplayer). And in my case the CPU usage is 2-3% 
systime, <1% userspace so it doesn't seem to be anything to do with the 
scheduler (I did try that "echo 1 > /proc/sys/kernel/sched_compat_yield" 
workaround, too.)


//T

> Regards,
> Willy
