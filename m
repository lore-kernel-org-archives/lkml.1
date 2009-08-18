Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZHRUd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZHRUd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZHRUd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:33:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbZHRUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:33:56 -0400
Date: Tue, 18 Aug 2009 13:33:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] irq fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.00.0908172342400.2782@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908181330210.3158@localhost.localdomain>
References: <alpine.LFD.2.00.0908172055360.2782@localhost.localdomain> <alpine.LFD.2.01.0908171340540.3162@localhost.localdomain> <alpine.LFD.2.00.0908172342400.2782@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Aug 2009, Thomas Gleixner wrote:
> 
> I have no idea what went wrong this time. I force pushed the branch
> and pulled it back on a test machine to compile and test boot. The
> test machine still has the correct sha1 for that branch while
> master.kernel.org did not. I probably pushed out some other branch
> between the point where I sent the pull request and the time you
> pulled, but I can not find any hint in my bash history which would
> explain why it wreckaged the irq-fixes-for-linus branch.
> 
> Just double checked that it is pushed out to git://.... as well.

It's still wrong. 

	http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=irq-fixes-for-linus

still does _not_ show that

	genirq: Do not wakeup irq thread from __setup_irq() and set action->irq

commit, but the broken one.

		Linus
