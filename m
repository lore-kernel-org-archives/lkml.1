Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbXJaQkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbXJaQkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbXJaQk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:40:27 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:33010 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287AbXJaQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:40:26 -0400
Date: Wed, 31 Oct 2007 12:39:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
In-Reply-To: <20071031092803.0048d5d6@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.58.0710311237010.17800@gandalf.stny.rr.com>
References: <1193788979.5623.43.camel@localhost.localdomain>
 <20071031071907.2d1b02ed@laptopd505.fenrus.org>
 <Pine.LNX.4.58.0710311034410.16249@gandalf.stny.rr.com>
 <20071031092803.0048d5d6@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 31 Oct 2007, Arjan van de Ven wrote:

> On Wed, 31 Oct 2007 11:00:56 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I've had too many issues in development where I hit a panic and it
> > gives me nothing to tell me why.
> >
> > At the very least, we should have a dump_stack in areas that are
> > usually caused by kernel bugs. For example, killing an interrupt
> > handler.
> >
>
> here's the deal.... the killing of an interrupt handler because of an
> oops THEN causes a panic. If you dump stack AGAIN, you have 2 stack
> traces, with the first one being the real good one, and the second one
> being.. well more crappy... so you proposal just dropped the good
> stacktrace off the screen in favor of a worse one...

Could be just a development glitch on my part, but there were times (IIRC)
I would not get a dump from a fault inside the interrupt handler, but I
would get the report of the killing of the interrupt handler.

Seems that I need to start recording the issues I've had with a kernel bug
not dumping a stack and doing a panic (which did nothing). And then I can
get back to you ;-)

-- Steve

