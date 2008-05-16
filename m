Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbYEPXp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbYEPXp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYEPXpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:45:17 -0400
Received: from www.tglx.de ([62.245.132.106]:33845 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYEPXpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:45:16 -0400
Date: Sat, 17 May 2008 01:44:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Linus Torvalds wrote:
> On Sat, 17 May 2008, Thomas Gleixner wrote:
> > 
> > please pull the latest x86 fixes from:
> > 
> >    ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> 
> No.
> 
> You have three real commits there.
> 
> And *six* unnecessary merges.

Hmm, I saw that coming :)

> Why do you merge my tree? Is it the x86 tree, or is it the "general 
> development tree"?
> 
> If it's the x86 tree, it shouldn't need to merge everythign else all the 
> time. Certainly not if it means that moer than half the commits are just 
> merges.
> 
> Do nice topic branches, where each branch has a reason for existing. The 
> "x86-fixes-for-linus" branch has x86 fixes. 

We have topic branches. How should we keep those topic branches up
to date ? By rebasing ?
 
> This happens almost every time somebody starts using git properly: at that 
> point the rebasing no longer hides bad habits.

We did not rebase at all. All we did is keeping the branches up to
date vs. your tree, which introduces merges whether we want or
not. I'm well aware of the merge commit issue, but I have no real good
idea how to avoid rebasing in order to keep the history intact and
avoid the merge commits at the same time.

Thanks,
	tglx



    
