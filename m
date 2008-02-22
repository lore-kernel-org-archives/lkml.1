Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbYBVJrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbYBVJrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbYBVJrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:47:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58241 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbYBVJrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:47:12 -0500
Date: Fri, 22 Feb 2008 10:46:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <glommer@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       arjan@infradead.org
Subject: Re: [PATCH 2/2] make work have a static address in do_boot_cpu()
Message-ID: <20080222094628.GB6269@elte.hu>
References: <1203626456-3101-1-git-send-email-gcosta@redhat.com> <1203626456-3101-2-git-send-email-gcosta@redhat.com> <1203626456-3101-3-git-send-email-gcosta@redhat.com> <1203631967.6112.16.camel@lappy> <5d6222a80802211457s2beb4d5cre331bc800c28d111@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80802211457s2beb4d5cre331bc800c28d111@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
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


* Glauber Costa <glommer@gmail.com> wrote:

> >  Looks way overkill. Doesn't something like:

> >  >       struct create_idle create_idle = {
> >  > -             .work = __WORK_INITIALIZER(create_idle.work, do_fork_idle),
> >  >               .cpu = cpu,
> >  >               .done = COMPLETION_INITIALIZER_ONSTACK(create_idle.done),
> >  >       };
> >  > +     INIT_WORK(&create_idle.work, do_fork_idle);
> >
> >  work?
> 
> Indeed.
> 
> I missed the static lock_class_key definition inside INIT_WORK macro. 
> It does the job neatly.

could you resend the updated patch?

	Ingo

