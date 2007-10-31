Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbXJaK7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbXJaK7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXJaK7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:59:23 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:32992 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbXJaK7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:59:22 -0400
Date: Wed, 31 Oct 2007 06:58:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
In-Reply-To: <20071031104147.GA27084@one.firstfloor.org>
Message-ID: <Pine.LNX.4.58.0710310653190.12724@gandalf.stny.rr.com>
References: <1193788979.5623.43.camel@localhost.localdomain>
 <p73odeg2l9v.fsf@bingen.suse.de> <20071031081513.GB3810@infradead.org>
 <20071031104147.GA27084@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 31 Oct 2007, Andi Kleen wrote:

> On Wed, Oct 31, 2007 at 08:15:13AM +0000, Christoph Hellwig wrote:
> > On Wed, Oct 31, 2007 at 01:14:04AM +0100, Andi Kleen wrote:
> > > One (mostly psychological, but still serious) problem is that stack
> > > dumps make panics always look like kernel bugs.  But there are panics
> > > which are definitely not kernel bugs: like the popular cannot mount
> > > root or machine checks or a couple of others.
> >
> > But that one really shouldn't be a panic anyway.  The panic alone
> > is psycologically bad enough for users.  I think it would be best to
> > have a simple scanf loop asking for another root device..
>
> Then you couldn't recover with panic=30 from it.
>
> Besides even if you fix that one there are others, like machine checks
> where it is impossible to recover.

Thinking about this more. Of the Linux users I asked, they think a kernel
panic is a bug in the kernel anyway (or at least something in the kernel
went wrong).  So if panics will point users to the kernel anyway, then why
leave out possible vital information from those panics that were caused by
an actual kernel bug.

-- Steve

