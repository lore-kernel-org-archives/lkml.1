Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbXKHUPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbXKHUPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761177AbXKHUPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:15:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761024AbXKHUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:15:41 -0500
Date: Thu, 8 Nov 2007 12:15:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 breaks C-state support on Intel T7200 x86_64
Message-Id: <20071108121536.8eeafb62.akpm@linux-foundation.org>
In-Reply-To: <20071108200352.GA5538@linux.intel.com>
References: <3624.1194542384@turing-police.cc.vt.edu>
	<20071108100212.0cbff318.akpm@linux-foundation.org>
	<20071108200352.GA5538@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Nov 2007 12:03:52 -0800 Mark Gross <mgross@linux.intel.com> wrote:
> ...
> > >   call.
> > > 
> > > I shouldn't have to have a process open a /dev/file, write a number, and then
> > > stay around forever so the file doesn't close in order to get the same behavior
> > > I was getting by default before.  What needs to happen to get this to not
> > > be a behavior regression/change?
> > > 
> > 
> > That's a great report, thanks.  Over to you, Mark ;)
> > 
> > btw, I also have a note here that these patches caused Rafael to see an
> > smp_call_function() inside local_irq_save().  Did that get fixed?
> 
> Ah, I see the problem.  I think I posted a fix to this.  The problem is
> that what's in the mm1 tree has a parameter PM_QOS_IDLE that needed to
> be PM_QOS_CPU_DMA_LATENCY. 

That doesn't ring a bell.

> I'm not sure what's in the current MM tree at this point so I can't say
> its been fixed.  Is there an easy way from me to see what's currently in
> MM?  

Not terribly. 
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
is from two days ago.

> FWIW I think I fixed this when I fixed up Rafael's issue.  Would you
> like me to send out a re-fresh patch against 2.6.23-mm1?

sure.
