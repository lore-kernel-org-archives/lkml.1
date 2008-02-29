Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYB2CL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYB2CL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYB2CLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:11:20 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbYB2CLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:11:19 -0500
Date: Thu, 28 Feb 2008 18:10:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-Id: <20080228181054.dddcf559.akpm@linux-foundation.org>
In-Reply-To: <20080229130019.3ede8053.sfr@canb.auug.org.au>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx>
	<1204180441-8540-4-git-send-email-matthew@wil.cx>
	<1204180441-8540-5-git-send-email-matthew@wil.cx>
	<1204180441-8540-6-git-send-email-matthew@wil.cx>
	<1204180441-8540-7-git-send-email-matthew@wil.cx>
	<1204180441-8540-8-git-send-email-matthew@wil.cx>
	<1204180441-8540-9-git-send-email-matthew@wil.cx>
	<1204180441-8540-10-git-send-email-matthew@wil.cx>
	<1204180441-8540-11-git-send-email-matthew@wil.cx>
	<20080228071822.GA13571@elte.hu>
	<20080229003954.GA525@parisc-linux.org>
	<20080229130019.3ede8053.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 13:00:19 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Thu, 28 Feb 2008 17:39:54 -0700 Matthew Wilcox <matthew@wil.cx> wrote:
> >
> > Stephen, I've put the semaphore patches into a git tree; can you add it
> > to linux-next?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=semaphore
> 
> I have put this in for toady's build (but using the git URL).  This tree
> is in the "too many conflicts and its out until fixed" category ...

A shame.

Most of the conflicts will be due to all the

-#include <asm/semaphore.h>
+#include <linux/semaphore.h>

but they're all optional anyway, because include/asm-*/semaphore.h is

#include <linux/semaphore.h>

so either a) you just ignore all those conflicts or b) we ask Willy to
remove all that stuff and we can trickle it in via subsystems later.

