Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXGCAh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXGCAh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbXGCAhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:37:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4187 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbXGCAhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:37:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 2 Jul 2007 17:37:17 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
In-Reply-To: <a36005b50707021728q2b5cac73qde36ed063a82eb24@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707021733080.14774@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0> 
 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com> 
 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com> 
 <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com> 
 <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0706301529310.2957@alien.or.mcafeemobile.com> 
 <a36005b50707010925k5c936c1ch2238b560c595a833@mail.gmail.com> 
 <Pine.LNX.4.64.0707011003510.7547@alien.or.mcafeemobile.com> 
 <a36005b50707020709s87bde71m325a4ced02eb6e2b@mail.gmail.com> 
 <Pine.LNX.4.64.0707021119460.14774@alien.or.mcafeemobile.com>
 <a36005b50707021728q2b5cac73qde36ed063a82eb24@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Ulrich Drepper wrote:

> > But there are
> > examples (and the signal stuff is one of them), where you do need the
> > set_context+syscall+unset_context abstraction, for all cases where the
> > kernel already has its own internal data strctures. In those cases you'd
> > have to spread sys_internal context knowledge all around the kernel,
> > whereas the current solution allows you to confine the code inside
> > kernel/indirect.c
> 
> Nonsense.  Whether you have a new word in the task structure or a
> pointer to a structure, you have to embed knowledge of this
> indirection in every affected code paths.  There is no difference
> here.  The only difference is that trying to force everything through
> an artificially complicated common entry code.
> 
> I hope that Andrew+Linus will see through this.  I'm done arguing.

I simply asked you to look how the code/patch would look like to handle 
the ppoll/pselect/epoll_pwait stuff, and precisely where your changes had 
to go. Or even in the exmaple Linus made of "make the fsuid/fsgid 
temporarily be my _real_ uid/gid for this single system call" for what it 
matters.



- Davide


