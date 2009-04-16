Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZDPUsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZDPUsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZDPUr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:47:57 -0400
Received: from thunk.org ([69.25.196.29]:43636 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZDPUr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:47:56 -0400
Date: Thu, 16 Apr 2009 16:46:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Add "how to write a good patch summary"
	to SubmittingPatches
Message-ID: <20090416204650.GN7138@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
References: <1239882285-4994-1-git-send-email-tytso@mit.edu> <20090416201255.GA21608@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416201255.GA21608@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 10:12:55PM +0200, Ingo Molnar wrote:
> as a bug triager i can, within 1 minute, sort all the commits by 
> risk:
> 
> Low risk cleanups:
>     ...
> Runtime crash fixes:
>     ...
> Robustness enhancements:
>     ...
> Low-risk features:
>     ...
> High-risk features:
>     ...

Sure, but if that's the goal, maybe instead we should have some
keywords that we tag onto one-line summary, i.e.

ext4 <LR,cleanup>: 
ext4 <MR,feature>: 
ext4 <HR,crashfix>:
ext4 <MR,robustness>:
ext4 <MR,errorcheck>:

That way it would become even *easier* for someone sorting through the
output of "git log --oneline".  (Note that sometimes a crash fix can
be either high, medium, and low risk --- and even there we will have
some differences between maintainers; but I think three categories is
sustainable.  At least it gives some differentiation between commits
within one subsystem.)

> And that's just 18 commits. We have 10,000 commits in every kerenel 
> cycle, and more than 1000 commits of that go via the trees hpa and 
> me is maintaining. It's 2-3 orders of a magnitude difference.

Right, but separating the Imact line from the one-line summary, and
not having an even *more* rigid and compact set of tags means we
should be able to make things even easier.

My main complaint with the Impact line is that given the stated goals,
it's too freeform, and it's separated from the patch summary.  The
rest of the body of the commit is free-form.  So if the goal is to
make it easy to sort through 10,000 commits, let's take even further.

Best regards,

					- Ted
