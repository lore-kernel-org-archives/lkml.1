Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbXJaLRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbXJaLRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXJaLR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:17:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32878 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbXJaLRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:17:25 -0400
Date: Wed, 31 Oct 2007 12:17:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
Message-ID: <20071031111724.GB27084@one.firstfloor.org>
References: <1193788979.5623.43.camel@localhost.localdomain> <p73odeg2l9v.fsf@bingen.suse.de> <20071031081513.GB3810@infradead.org> <20071031104147.GA27084@one.firstfloor.org> <Pine.LNX.4.58.0710310653190.12724@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0710310653190.12724@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Thinking about this more. Of the Linux users I asked, they think a kernel
> panic is a bug in the kernel anyway (or at least something in the kernel
> went wrong).  So if panics will point users to the kernel anyway, then why
> leave out possible vital information from those panics that were caused by
> an actual kernel bug.

On a no root found panic (which are likely the majority of all panics) 
the stack dump is about 100% useless.

I also think it's a very bad idea to add them to machine checks again
for psychological reasons.

-Andi

