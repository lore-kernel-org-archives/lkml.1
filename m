Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXKSQPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXKSQPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXKSQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:14:58 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:44272 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbXKSQO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:14:58 -0500
Date: Mon, 19 Nov 2007 17:14:55 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
Message-Id: <20071119171455.c05793a0.dada1@cosmosbay.com>
In-Reply-To: <4741B047.9080601@redhat.com>
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com>
	<20071119145224.31ee5242.dada1@cosmosbay.com>
	<4741A7DD.1030407@redhat.com>
	<20071119164329.5a580b84.dada1@cosmosbay.com>
	<4741B047.9080601@redhat.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 07:48:23 -0800
Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Dumazet wrote:
> > So when you recompile your old program (as you post it and as I commented on),
> > it will pass a >= 12 bytes data to kernel, with only first 4 bytes set to O_CLOEXEC.
> > 
> > Other bytes will contain junk 
> 
> If you don't initialize the entire structure and you use it all, of
> course you get undefined behavior.  That's nothing new.  The program I
> attached is not an example, it's a test for the functionality in this patch.
> 
> Like with every kernel interface, you have to use it correctly.  The
> good news is that user programs should never use this syscall directly
> (just like don't for existing ones).
> 
> I see no problem at all here.

I do see a problem, because some readers will take your example as a reference,
as it will probably sit in a page that google^Wsearch_engines will bring at the
top of search results for next ten years or so. 

(I bet for "sys_indirect syscall" -> http://lwn.net/Articles/258708/ )

Next time you post it, please warn users that it will break in some years, or
state clearly this should only be used internally by glibc.

Thank you
