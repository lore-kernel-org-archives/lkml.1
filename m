Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZHFMeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZHFMeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZHFMeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:34:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33011 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZHFMeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:34:17 -0400
Date: Thu, 6 Aug 2009 14:34:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, airlied@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: do not use functions starting
	with .L in recordmcount.pl
Message-ID: <20090806123407.GC15314@elte.hu>
References: <alpine.DEB.2.00.0908052011590.5010@gandalf.stny.rr.com> <tip-3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8@git.kernel.org>
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


* tip-bot for Steven Rostedt <rostedt@goodmis.org> wrote:

> Commit-ID:  3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8
> Gitweb:     http://git.kernel.org/tip/3f6e968ef4e1d8d93d8a8505461b0e50a9e97ad8
> Author:     Steven Rostedt <rostedt@goodmis.org>
> AuthorDate: Wed, 5 Aug 2009 22:00:14 -0400
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Wed, 5 Aug 2009 22:45:07 -0400
> 
> tracing: do not use functions starting with .L in recordmcount.pl
> 
> On Wed, 5 Aug 2009, Ingo Molnar wrote:
> > * Dave Airlie <airlied@gmail.com> wrote:
> >
> > > Hey,
> > >
> > > So I spent 3-4 hrs today (I'm stupid yes) tracking down a .o
> > > breakage by blaming rawhide gcc/binutils as I was using make
> > > V=1and seeing only the compiler chain running,
> >
> > Hm, is this that powerpc related build bug you just reported?

Btw., a small nitpick for future commit logs: it would have been 
nice to keep this email quote excerpt out of the changelog, it looks 
a bit messy. If it contains useful info then it can be paraphrased 
into the usual 'Dave Airlie reported ...' sentence(s).

Thanks,

	Ingo
