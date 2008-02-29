Return-Path: <linux-kernel-owner+w=401wt.eu-S933182AbYB2QP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbYB2QP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbYB2QPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:15:18 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756487AbYB2QPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:15:17 -0500
Date: Fri, 29 Feb 2008 08:14:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
In-Reply-To: <20080229130019.3ede8053.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.1.00.0802290809580.17889@woody.linux-foundation.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx> <1204180441-8540-4-git-send-email-matthew@wil.cx> <1204180441-8540-5-git-send-email-matthew@wil.cx> <1204180441-8540-6-git-send-email-matthew@wil.cx> <1204180441-8540-7-git-send-email-matthew@wil.cx>
 <1204180441-8540-8-git-send-email-matthew@wil.cx> <1204180441-8540-9-git-send-email-matthew@wil.cx> <1204180441-8540-10-git-send-email-matthew@wil.cx> <1204180441-8540-11-git-send-email-matthew@wil.cx> <20080228071822.GA13571@elte.hu> <20080229003954.GA525@parisc-linux.org>
 <20080229130019.3ede8053.sfr@canb.auug.org.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Stephen Rothwell wrote:
>
> On Thu, 28 Feb 2008 17:39:54 -0700 Matthew Wilcox <matthew@wil.cx> wrote:
> >
> > Stephen, I've put the semaphore patches into a git tree; can you add it
> > to linux-next?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore
> 
> I have put this in for toady's build (but using the git URL).  This tree
> is in the "too many conflicts and its out until fixed" category ...
> However, it is also a candidate for Linus' "next" branch (if he is going
> to run one ...).

I'm not going to do a "next" branch just for stupid syntactic merge errors 
that are trivially fixed due to some include-file moving. If 
submaintainers can fix it up trivially, it's really not worth it. 

				Linus


