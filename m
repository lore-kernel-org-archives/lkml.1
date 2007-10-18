Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbXJRUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbXJRUBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbXJRUBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:01:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34615 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXJRUBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:01:11 -0400
Date: Thu, 18 Oct 2007 22:00:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: latest checkpatch
Message-ID: <20071018200057.GA29856@elte.hu>
References: <20071015182118.GA4459@shadowen.org> <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org> <20071018111352.GA17039@elte.hu> <20071018192521.GC21136@shadowen.org> <20071018194304.GD21136@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018194304.GD21136@shadowen.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <apw@shadowen.org> wrote:

> > >   +                               SD_BALANCE_FORK |
> > >   +                               SD_BALANCE_EXEC |
> > >   +                               SD_SHARE_CPUPOWER |
> > >   +                               SD_SHARE_PKG_RESOURCES);
> > >   +       }
> > > 
> > > (there's another place in sched.c that trips this up too.)
> 
> Ok, checkpatch.pl-next should now no longer trip up on this statement.

indeed it works fine - thanks! kernel/sched.c is now down to:

  total: 0 errors, 1 warnings, 6990 lines checked

(and that 1 warning is a correct warning from checkpatch.pl.)

	Ingo
