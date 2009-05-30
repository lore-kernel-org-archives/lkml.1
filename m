Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbZE3Ork@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbZE3Ork (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZE3Orc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:47:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119AbZE3Orc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:47:32 -0400
Date: Sat, 30 May 2009 16:47:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Generate per
	command manpages (and pdf/html, etc.)
Message-ID: <20090530144712.GB31326@elte.hu>
References: <tip-c1c2365acf8c044f749c0fe1ea236497e8d1718e@git.kernel.org> <20090530134601.GA12088@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530134601.GA12088@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, May 30, 2009 at 01:00:33PM +0000, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  c1c2365acf8c044f749c0fe1ea236497e8d1718e
> > Gitweb:     http://git.kernel.org/tip/c1c2365acf8c044f749c0fe1ea236497e8d1718e
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Sat, 30 May 2009 12:38:51 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 30 May 2009 13:52:44 +0200
> > 
> > perf_counter tools: Generate per command manpages (and pdf/html, etc.)
> > 
> > Import Git's nice .txt => {man/html/pdf} generation machinery.
> > 
> > Fix various errors in the Documentation/perf*.txt description as well.
> > 
> > Also fix a bug in builtin-help: we'd map 'perf help top' to 'perftop'
> > if only the 'perf' binary is in the default PATH - confusing the manpage
> > logic. I dont fully understand why Git did it this way - but i suppose
> > it's a migration artifact from their migration from standalone git-xyz
> > commands to 'git xyz' commands. The perf tools were always using the
> > modern form so it's not an issue there.
> 
> Can we please have this patch split in at least a infrastructire 
> and a content part.

> This makes it easier to review - and also makes it much more clear 
> what is needed to be added when adding new documentation following 
> this format.

The .txt files were already present, so the patch is largely the 
infrastructure patch. The fixes to .txt files were minimal.

> I would also suggest to copy Randy Dunlap on patches touching 
> generic parts like this in Documentation.

Sure - if Randy shows interest in perfcounters bits i can Cc: him. 
Note, it isnt touching generic parts of Documentation/. It's 
touching the Documentation/perf_counter/ tools only.

	Ingo
