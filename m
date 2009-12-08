Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZLHLO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZLHLO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZLHLOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:14:24 -0500
Received: from www.tglx.de ([62.245.132.106]:45629 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbZLHLOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:14:23 -0500
Date: Tue, 8 Dec 2009 12:14:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT pull] bkl core patches for 2.6.33
In-Reply-To: <m1iqci4ful.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.0912081211350.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain> <m1iqci4ful.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > Linus,
> >
> > Please pull the latest bkl-core-for-linus git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git bkl-core-for-linus
> >
> > Thanks,
> 
> 
> Was this tree in linux-next?  I'm certain I would have remembered the
> conflict in kernel/sysctl.c.  Among other things in my sysctl tree
> lock_kernel() is gone.  The removal of lock_kernel() happened to fall
> out of my other changes.  I remember having a conversation with Arnd
> Bergmann about this, and the conclusion being was that my change
> correct and superior to this patch.  So I'm surprised a sysctl change
> made it into your tree.

Sorry, that change was excluded from next and I completely forgot
about your patches when I was preparing the pull request. Zapped the
commit in question already.

Thanks,

	tglx


