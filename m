Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYBJJej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYBJJej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBJJe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:34:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37953 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYBJJe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:34:27 -0500
Date: Sun, 10 Feb 2008 10:34:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210093407.GA20183@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082132.GA9878@elte.hu> <20080210082624.GB10479@infradead.org> <20080210090817.GA15409@elte.hu> <20080210091757.GA17341@elte.hu> <20080210092023.GA18451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210092023.GA18451@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > tip 2e3ebf25b0bd8646e517806073e1991be1fec8a2. Shortlog, diffstat and 
> > the full patch can be found below, with all relevant review feedback 
> > addressed. Builds, boots and works fine on x86.
> 
> here's gdb test-output from this 2e3ebf25b0bd kernel:

i should also mention that yesterday's tree passed 200 randconfig bootup 
tests on 32-bit and 64-bit x86. (i excluded CONFIG_WMI from ACPI, plus 3 
other ACPI commits because they keept crashing boxes or broke the build)

Today's kgdb updates are in the trivial category so i'd not expect them 
to break anything, but nevertheless, out of caution i threw the latest 
tree into the qa mix as well and they already passed 10 randconfig 
bootup tests.

[ and this matches my experience with KGDB stability in the last few
  months while we carried and tested it in x86.git: even the old, much
  wider-scope and uglier/riskier patches that hooked in a lot of places
  never broke anything unrelated (or anything in fact) - and this
  matches kgdb's -mm track record as well. ]

	Ingo
