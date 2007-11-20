Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXKTOL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXKTOL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXKTOLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:11:19 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:50105 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXKTOLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:11:19 -0500
Date: Tue, 20 Nov 2007 06:11:17 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
In-Reply-To: <20071119190826.GD12650@elte.hu>
Message-ID: <alpine.DEB.0.99999.0711200609240.765@twinlark.arctic.org>
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <20071119145224.31ee5242.dada1@cosmosbay.com> <4741A7DD.1030407@redhat.com> <20071119164329.5a580b84.dada1@cosmosbay.com> <4741B047.9080601@redhat.com> <20071119171455.c05793a0.dada1@cosmosbay.com>
 <20071119190826.GD12650@elte.hu>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Ingo Molnar wrote:

> 
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > I do see a problem, because some readers will take your example as a 
> > reference, as it will probably sit in a page that 
> > google^Wsearch_engines will bring at the top of search results for 
> > next ten years or so.
> > 
> > (I bet for "sys_indirect syscall" -> http://lwn.net/Articles/258708/ )
> > 
> > Next time you post it, please warn users that it will break in some 
> > years, or state clearly this should only be used internally by glibc.
> 
> dont be silly, next time Ulrich should also warn everyone that running 
> attachments and applying patches from untrusted sources is dangerous?
> 
> any code that includes:
> 
>   fd = syscall (__NR_indirect, &r, &i, sizeof (i));
> 
> is by definition broken and unportable in every sense of the word. Apps 
> will use the proper glibc interfaces (if it's exposed).

as an application writer how do i access accept(2) with FD_CLOEXEC 
functionality?  will glibc expose an accept2() with a flags param?  if 
so... why don't we just have an accept2() syscall?

-dean
