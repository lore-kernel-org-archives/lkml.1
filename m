Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYEQAEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYEQAEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYEQAEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:04:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759531AbYEQAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:04:06 -0400
Date: Fri, 16 May 2008 17:03:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0805161658450.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Thomas Gleixner wrote:
> 
> We have topic branches. How should we keep those topic branches up
> to date ? By rebasing ?

Listen to yourself. They are "topic" branches. They are supposed to do one 
thing. You keep them "uptodate" by doing your work on them, _not_ by 
merging everybody elses work into them.

> > This happens almost every time somebody starts using git properly: at that 
> > point the rebasing no longer hides bad habits.
> 
> We did not rebase at all.

You _used_ to rebase. That hides bad workflows, because it hides the fact 
that your "topic branch" is not a topic branch at all, but something that 
tries to do much more than it's stated purpose.

So now, when you stopped rebasing, the fact that you keep updating your 
topic branches with code that has nothing to do with your topic (ie code 
that I randomly merged from me) is visible as the unnecessary merges.

Yes, doing a merge occasionally just to not fell *too* far behind is sane. 
But when you have twice as many merges as you have real commits, you're 
doing something wrong. At that point, you're no longer a topic branch, 
you're just a mess of other peoples development merged on top of random 
commits you do.

See the difference? You literally merged four times in two days. That's 
not "keeping reasonably up-to-date", that's just messy and OCD.

		Linus
