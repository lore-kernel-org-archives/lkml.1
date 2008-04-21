Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYDUQyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYDUQyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYDUQyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:54:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48053 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYDUQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:54:22 -0400
Date: Mon, 21 Apr 2008 10:54:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [DOC PATCH] Remove mention of semaphores from kernel-locking
Message-ID: <20080421165405.GB20637@parisc-linux.org>
References: <20080421145230.GX20637@parisc-linux.org> <200804220215.30855.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804220215.30855.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 02:15:30AM +1000, Rusty Russell wrote:
> >     <title>Three Main Types of Kernel Locks: Spinlocks, Mutexes and
> > Semaphores</title>
> >
> >     <para>
> > -     There are three main types of kernel locks.  The fundamental type
> > +     There are two main types of kernel locks.  The fundamental type
> >       is the spinlock
> >       (<filename class="headerfile">include/asm/spinlock.h</filename>),
> >       which is a very simple single-holder lock: if you can't get the
> 
> Fix title, too?

Heh.  Oops, thanks.

> Thanks for the other fixes too; this document needs some love,

No problem ... I started out augmenting it to discuss semaphores and
mutexes properly and realised I'd totally overloaded this document with
detail.  I'm tempted to rip the RCU pieces out of this document and
create a new one.  What we currently have just doesn't read nicely [1],
but this is a project for another day.

> Acked,
> Rusty.

I'll add your ack.  Thanks!

[1] This seems to be a common problem in Linux's Documentation/ directory
... just _read_ CodingStyle and you can tell which bits are Linus'
(funny, deprecating, suggestions) and which bits were added later
(stern, prescriptive, fascist).  The later bits break the flow of the
document and I find them quite jarring.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
