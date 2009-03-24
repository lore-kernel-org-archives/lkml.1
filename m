Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZCXG7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZCXG7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZCXG7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:59:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZCXG7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:59:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: mtk.manpages@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linux API <linux-api@vger.kernel.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
In-Reply-To: Thomas Gleixner's message of  Monday, 23 March 2009 12:14:59 +0100 <alpine.LFD.2.00.0903231213180.29264@localhost.localdomain>
References: <20090226133339.875832967@linutronix.de>
	<cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
	<20090227000352.7D32BFC339@magilla.sf.frob.com>
	<alpine.LFD.2.00.0903231213180.29264@localhost.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090324065858.153BAFC3AB@magilla.sf.frob.com>
Date: Mon, 23 Mar 2009 23:58:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't see any rationale for rt_tgsigqueueinfo and rt_sigqueueinfo to
> > differ in their treatment of si_pid/si_uid (whatever that is).  It just
> > seems like common sense that they would match.
> > 
> > Oleg and/or Sukadev have some patches floating around (maybe all in -mm?)
> > that relate to setting those.
> 
> You mean having the same logic as we have in {t,tg,}kill syscalls for
> rt_sigqueueinfo as well ?

I mean just what I said: rt_tgsigqueueinfo's treatment of the siginfo_t
should match rt_sigqueueinfo's.  Make it match rt_sigqueueinfo today and
make sure that if rt_sigqueueinfo changes, then rt_tgsigqueueinfo will
change to match.

> Is there anything else which stands in the way of getting the
> rt_tgsigqueueinfo interface merged ?

I don't see any problem.  But you should at least make sure that Ulrich
likes the syscall interface for implementing pthread_sigqueue or whatever
it will be.


Thanks,
Roland
