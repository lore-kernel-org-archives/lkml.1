Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbXH2Wv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbXH2Wv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbXH2Wvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:51:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756973AbXH2Wvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:51:48 -0400
Date: Wed, 29 Aug 2007 15:51:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: ebiederm@xmission.com (Eric W. Biederman),
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
Message-Id: <20070829155136.966f5c8f.akpm@linux-foundation.org>
In-Reply-To: <20070829114604.242b976c@the-village.bc.nu>
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com>
	<m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>
	<20070829114604.242b976c@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 11:46:04 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > >> adequate job of warning our users.  A printk when we run a program
> > >> that uses the binary interface and an long enough interval the warning
> > >> makes it to the Enterprise kernels before we remove the interface
> > >> should be sufficient.
> 
> The enterprise products will probably just remove the printk. Even if
> they didn't you are looking at ten years before things finish changing
> based on current experiences, probably longer as things stabilize.

If that happens then the enterprise vendors will tell us (won't they).  We
can then discuss it and we may well elect to do something different.

But Eric is predicting that this probably _won't_ happen.  There's only one
way to find out.

> The whole "whine a bit" process simply doesn't work when you are trying
> to persuade people to move in a non-hobbyist context.

Eric thinks there will be little if any moving to be done.

> They don't want to
> move, the message is simply an annoyance, their upstream huge package
> vendor won't change just to deal with it and they'll class it as a
> regression from previous releases, an incompatibility and file bugs until
> it goes away.
> 
> Its user ABI and as Linus said - we don't break it. Trimming down all the
> crap that never worked via sysctl is one thing, not putting sysctl in new
> platforms likewise. Trying to undo it isn't going to work
> 

We don't know that yet.  You may be right, or maybe Eric is right.  Let's
find out.
