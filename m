Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbZDQB1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbZDQB1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZDQB1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:27:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55057 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbZDQB1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:27:39 -0400
Date: Fri, 17 Apr 2009 03:25:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Message-ID: <20090417012544.GB16126@elte.hu>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <alpine.LFD.2.00.0904161738030.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904161738030.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> I think you put this in the wrong regression pile:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13112
> > Subject		: Oops in drain_array
> > Submitter	: Bart <mmx@riz.pl>
> > Date		: 2009-04-14 10:21 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123970493224628&w=4
> 
> Hmm. This one seems like it should be in the "since 2.6.28" camp, since if 
> I read that one right, it happens with 2.6.29.1.
> 
> (I mean sure, it might be new since 2.6.29, but it sounds more likely that 
> it's already in 2.6.29)

I'd suspect it's possibly hardware related:

  http://www.kerneloops.org/search.php?search=free_block&btnG=Function+Search

Look at the very similar call signatures - spanning almost all 
kernels back to v2.6.16. There's one spike at .27 - perhaps the same 
box trying up hard and crashing several times - or a popular distro 
kernel?

Or it's a really ancient bug going back to v2.6.16.

	Ingo
