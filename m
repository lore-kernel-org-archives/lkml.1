Return-Path: <linux-kernel-owner+w=401wt.eu-S1763745AbZFMVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745AbZFMVGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZFMVGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:06:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZFMVGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:06:31 -0400
Date: Sat, 13 Jun 2009 23:00:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open
	when supported
Message-ID: <20090613210018.GA1962@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> <20090612120507.GH16044@elte.hu> <8bd0f97a0906120816w26d91530nf1e1967470beb99c@mail.gmail.com> <20090612152134.GA23483@elte.hu> <8bd0f97a0906120829p628751e9gb557f6a14e98fae2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906120829p628751e9gb557f6a14e98fae2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Fri, Jun 12, 2009 at 11:21, Ingo Molnar wrote:
> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> >> the perf counter code explicitly requires:
> >> ...
> >>  - support for atomic64 types (unless i missed something, x86 is the
> >> only 32bit system that supports these)
> >
> > A wrapper suffices - should probably be librarized into lib/.
> 
> wonder if we can trick Arnd into doing that ...

FYI, Paul has posted the patches for generic atomic64_t today.

So the barrier of entry to perfcounters enablement is really low 
now, even for 32-bit architectures without 64-bit atomic ops.

	Ingo
