Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbYGOWBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbYGOWBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYGOWBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:01:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbYGOWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:01:05 -0400
Date: Tue, 15 Jul 2008 15:00:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] x86 updates
In-Reply-To: <alpine.LFD.1.10.0807152341240.3283@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0807151456490.2867@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org> <alpine.LFD.1.10.0807152341240.3283@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Thomas Gleixner wrote:
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=x86/urgent
> 
> has a commit on top of your tree. 
> 
> commit	     431ceb83f703a343bdd14350480a2224fa4bfedf
> tree	     2f4644aec0d326e23327ed2297a4a4f52b1d830e
> parent	     b9d2252c1e44fa83a4e65fdc9eb93db6297c55af
>
> I waited with the pull request until it showed up there.

I'd say it's a mirroring issue, but:

[torvalds@woody linux]$ git ls-remote ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git | grep x86/urgent
b9d2252c1e44fa83a4e65fdc9eb93db6297c55af	refs/heads/x86/urgent
b9d2252c1e44fa83a4e65fdc9eb93db6297c55af	refs/heads/x86/urgent-undo-ioapic
41b7aafd3ea22fcd6cbb062da39d5c757d6c09ca	refs/remotes/origin/x86/urgent

ie it looks like even master has b9d2252c1 as tip (which is the one you 
say is the parent).

I wonder if Ingo overwrote it. You both push to the same tree, don't you? 
And maybe somebody used "-f" to force an over-push?

			Linus
