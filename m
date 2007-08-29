Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbXH2KiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbXH2KiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 06:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXH2Khz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 06:37:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56156 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753292AbXH2Khy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 06:37:54 -0400
Date: Wed, 29 Aug 2007 11:46:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
Message-ID: <20070829114604.242b976c@the-village.bc.nu>
In-Reply-To: <m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com>
	<m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> adequate job of warning our users.  A printk when we run a program
> >> that uses the binary interface and an long enough interval the warning
> >> makes it to the Enterprise kernels before we remove the interface
> >> should be sufficient.

The enterprise products will probably just remove the printk. Even if
they didn't you are looking at ten years before things finish changing
based on current experiences, probably longer as things stabilize.

The whole "whine a bit" process simply doesn't work when you are trying
to persuade people to move in a non-hobbyist context. They don't want to
move, the message is simply an annoyance, their upstream huge package
vendor won't change just to deal with it and they'll class it as a
regression from previous releases, an incompatibility and file bugs until
it goes away.

Its user ABI and as Linus said - we don't break it. Trimming down all the
crap that never worked via sysctl is one thing, not putting sysctl in new
platforms likewise. Trying to undo it isn't going to work

Alan
