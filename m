Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYL2NZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYL2NZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYL2NZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:25:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57165 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbYL2NZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:25:31 -0500
Date: Mon, 29 Dec 2008 14:23:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>
Cc: Roland McGrath <roland@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Notify init when processes are reparented to it
Message-ID: <20081229132305.GA31210@redhat.com>
References: <1230378128.7026.50.camel@quest> <20081227114452.GA2919@zelda.netsplit.com> <20081228092024.GA21673@redhat.com> <20081228220122.62940FC278@magilla.sf.frob.com> <1230551457.4664.0.camel@wing-commander>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230551457.4664.0.camel@wing-commander>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Scott James Remnant wrote:
>
> On Sun, 2008-12-28 at 14:01 -0800, Roland McGrath wrote:
>
> > I'm highly skeptical that this is a desireable feature at all, and
> > certainly I find the abuse of siginfo_t.si_status here extremely
> > questionable.  I think we need a clear explanation of what problems
> > the feature is intended to address.
> >
> Did the original e-mail not address this?

Do you mean

	[RFC] Notify init when processes are reparented to it
	http://marc.info/?l=linux-kernel&m=123038049428388

?

I am not sure I really understand the problem. And thus I can't
understand how this patch can help.

OK,

> We want to be able to supervise daemons.

What do you mean?

> Later on, 1002 will die and init will receive SIGCHLD for it.
>
> Unfortunately neither the 1001 or 1002 processes are known to init, even
> though they are original children of the process it spawned (1000), for
> init to be notified about them - this has been forgotten.

Ok, with this patch /sbin/init knows that 1002 is a descendant
of apache(1000) which was spwaned by init. What can init do
with this info?

To clarify, I am not arguing, I am just trying to understand.

Oleg.

