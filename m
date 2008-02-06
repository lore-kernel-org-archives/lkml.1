Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYBFSGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYBFSGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbYBFSFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:05:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644AbYBFSFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:05:50 -0500
Date: Wed, 6 Feb 2008 10:05:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: softlockup: automatically detect hung TASK_UNINTERRUPTIBLE
 tasks
Message-Id: <20080206100513.133587fa.akpm@linux-foundation.org>
In-Reply-To: <1202309402.6310.0.camel@lappy>
References: <200801252259.m0PMxHmD012059@hera.kernel.org>
	<20080205164626.f9c920e0.akpm@linux-foundation.org>
	<1202309402.6310.0.camel@lappy>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 15:50:02 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Tue, 2008-02-05 at 16:46 -0800, Andrew Morton wrote:
> > On Fri, 25 Jan 2008 22:59:17 GMT
> > Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > 
> > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=82a1fcb90287052aabfa235e7ffc693ea003fe69
> > > Commit:     82a1fcb90287052aabfa235e7ffc693ea003fe69
> > > Parent:     d0d23b5432fe61229dd3641c5e94d4130bc4e61b
> > > Author:     Ingo Molnar <mingo@elte.hu>
> > > AuthorDate: Fri Jan 25 21:08:02 2008 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Fri Jan 25 21:08:02 2008 +0100
> > > 
> > >     softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
> > 
> > One of my test boxes (an 8-way x86_64 software-development thing from Intel
> > - I'm not sure what's inside it) no longer powers itself off when I run `halt
> > -pfn'.
> > 
> > During bisection I found two different problems.  Sometimes the machine
> > wouldn't power off at all.  Other times it would power off after a pause of
> > around twenty seconds.
> > 
> > Bisection indicates that this commit is what caused the 20-second pause. 
> > It could be that some later commit caused the infinity-second pause.
> 
> 
> Does that kernel have:
> 
> commit ed50d6cbc394cd0966469d3e249353c9dd1d38b9
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Sat Feb 2 00:23:08 2008 +0100
> 
>     debug: softlockup looping fix
> 
> 

yup.  It was fetched less than 24 hours ago.
