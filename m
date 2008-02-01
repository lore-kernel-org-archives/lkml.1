Return-Path: <linux-kernel-owner+w=401wt.eu-S965064AbYBAAub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064AbYBAAub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYBAAuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:50:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbYBAAuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:50:22 -0500
Date: Fri, 1 Feb 2008 11:48:44 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Matthew Wilcox <matthew@wil.cx>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Liam Howlett <howlett@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Pull request: TASK_KILLABLE
In-Reply-To: <20080131234504.GB25967@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0802011146180.3198@www.l.google.com>
References: <20080129000447.GC31101@parisc-linux.org> <alpine.LFD.1.00.0801292237480.3505@www.l.google.com> <20080131234504.GB25967@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jan 2008, Matthew Wilcox wrote:
> 
> To allow tasks to be interrupted by fatal signals, we introduce a new
> TASK_* bit; TASK_WAKEKILL.  We also add a predicate fatal_signal_pending;
> the counterpart of signal_pending().  Then we add killable versions
> of lock_page(), mutex_lock(), schedule_timeout(), wait_event(), and
> wait_for_completion().  Finally, we can make the NFS 'intr' mount option
> a no-op.

Ok, I've pulled this. It conflicted with some NFS changes, but I did what 
appeared to be the obvious conflict resolution, and it all at least 
compiles and it looked sane to me. But I don't have NFS enabled normally, 
and I certainly don't have a good way to test with my laptop while in 
Melbourne, so Trond/Matthew, can you please double- and triple-check my 
merge?

			Linus
