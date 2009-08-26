Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZHZSZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZHZSZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZHZSZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:25:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39540 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZHZSZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:25:04 -0400
Date: Wed, 26 Aug 2009 20:24:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: do not complain if root is owning perf.data
Message-ID: <20090826182459.GD13632@elte.hu>
References: <1251291926-27174-1-git-send-email-pierre.habouzit@intersec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251291926-27174-1-git-send-email-pierre.habouzit@intersec.com>
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


* Pierre Habouzit <pierre.habouzit@intersec.com> wrote:

> This improves patch fa6963b24 so that perf.data stuff that has 
> been dumped as root can be read (annotate/report) by a user 
> without the use of the --force.
> 
> Rationale is that root has plenty of ways to screw us (usually) 
> that do not require twisted schemes involving specially crafting a 
> perf.data.
> 
> Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
> ---
>  tools/perf/builtin-annotate.c |    4 ++--
>  tools/perf/builtin-report.c   |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Ok, this makes sense - but i think we should do this in .32 only, 
with a Cc: <stable@kernel.org> backport tag for .31.1.

Mind doing it against the latest perfcounters tree, which can be 
found in -tip:

  http://people.redhat.com/mingo/tip.git/README

your current version does not apply cleanly as the surrounding code 
has changed a bit already.

Thanks,

	Ingo
