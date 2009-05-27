Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbZE0W3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbZE0W3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZE0W31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:29:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35947 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbZE0W31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:29:27 -0400
Date: Thu, 28 May 2009 00:29:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck fixes for -tip
Message-ID: <20090527222919.GA20112@elte.hu>
References: <20090527054317.GA31443@damson.getinternet.no> <20090527072643.GA15000@elte.hu> <19f34abd0905270738r41abc15byc464133d184c24f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19f34abd0905270738r41abc15byc464133d184c24f7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> 2009/5/27 Ingo Molnar <mingo@elte.hu>:
> [...]
> 
> > Pulled, thanks Vegard! There were a few conflicts with tip:master,
> > due to ongoing work in other areas:
> >
> >    Merge branch 'kmemcheck'
> >
> >    Conflicts:
> >        include/linux/ring_buffer.h
> >        init/do_mounts.c
> >        kernel/trace/ring_buffer.c
> >
> > I resolved them manually, you might want to double check them.
> 
> Thanks. There seems to have been one interaction with this old commit
> from who knows what branch:
> 
> commit 899b5030558b8dc21a171e2e8129e0a93fb08860
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Apr 29 16:31:50 2008 +0200
> 
>     init: root mount fix
> 
>     Needs changelog
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> I think this commit can get chucked now, as I provided what I believe
> was the better workaround (to introduce a wrapper for getname() that
> takes GFP flags: commits 30066967f86f8b31fb7aef1f0a2214ae8d5a4b80 and
> 1c4018089bc978fa1ec3fc69d220ba432b1f075b). But the code as it stands
> will work as it should.

this comes from tip:out-of-tree.

Thanks for the reminder - i've zapped it.

> There's now also an indentation mismatch in
> include/linux/ring_buffer.h, line 16, in struct ring_buffer_event.
> 
> Don't know how you'd prefer to solve these, if at all? Should I 
> send patches against tip/master?

No - updating the kmemcheck branch is fine. Integration troubles are 
really the problem of -tip maintainers.

	Ingo
