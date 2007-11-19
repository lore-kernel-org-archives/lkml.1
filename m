Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbXKSTJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbXKSTJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbXKSTJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:09:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbXKSTJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:09:37 -0500
Date: Mon, 19 Nov 2007 20:08:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
Message-ID: <20071119190826.GD12650@elte.hu>
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <20071119145224.31ee5242.dada1@cosmosbay.com> <4741A7DD.1030407@redhat.com> <20071119164329.5a580b84.dada1@cosmosbay.com> <4741B047.9080601@redhat.com> <20071119171455.c05793a0.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119171455.c05793a0.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> I do see a problem, because some readers will take your example as a 
> reference, as it will probably sit in a page that 
> google^Wsearch_engines will bring at the top of search results for 
> next ten years or so.
> 
> (I bet for "sys_indirect syscall" -> http://lwn.net/Articles/258708/ )
> 
> Next time you post it, please warn users that it will break in some 
> years, or state clearly this should only be used internally by glibc.

dont be silly, next time Ulrich should also warn everyone that running 
attachments and applying patches from untrusted sources is dangerous?

any code that includes:

  fd = syscall (__NR_indirect, &r, &i, sizeof (i));

is by definition broken and unportable in every sense of the word. Apps 
will use the proper glibc interfaces (if it's exposed).

really, lets discuss _real_ issues. If you cannot think of any, please 
stay silent.

	Ingo
