Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZIVO7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZIVO7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZIVO7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:59:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbZIVO7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:59:34 -0400
Date: Tue, 22 Sep 2009 16:59:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20090922145924.GA2485@elte.hu>
References: <20090922075144.GA21122@elte.hu> <alpine.LFD.2.01.0909220749100.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909220749100.4950@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 22 Sep 2009, Ingo Molnar wrote:
> > 
> > Please pull the latest perf-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus
> > 
> > This fixes a brown paperbag build error in PowerPC caused by the rename.
> 
> Hmm. Forgot to push? I'm getting
> 
> 	fatal: Couldn't find remote ref perf-fixes-for-linus
> 
> but maybe it's due to exta-long mirroring delays too.

hm, i think it's mirroring - the repo itself looks good on 
master.kernel.org:

[mingo@hera tip]$ hostname
hera.kernel.org
[mingo@hera tip]$ git log perf-fixes-for-linus |head
commit a8f90e906783f1f815120eefe813b23cb396e9bd
Author: Paul Mackerras <paulus@samba.org>
Date:   Tue Sep 22 09:48:08 2009 +1000

    perf_event, powerpc: Fix compilation after big perf_counter rename
    
    This fixes two places in the powerpc perf_event (perf_counter) code
    where 'list_entry' needs to be changed to 'group_entry', but were
    missed in commit 65abc865 ("perf_counter: Rename list_entry ->
    group_entry, counter_list -> group_list").

	Ingo
