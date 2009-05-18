Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZERPNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZERPNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZERPNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:13:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbZERPNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:13:21 -0400
Date: Mon, 18 May 2009 17:11:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jonathan Corbet <corbet@lwn.net>,
       Martin Bammer <mrb74@gmx.at>, Jeff Garzik <jgarzik@pobox.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Message-ID: <20090518151102.GA6241@elte.hu>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <20090517073327.GC1583@elte.hu> <20090518145725.GB18607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518145725.GB18607@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/17, Ingo Molnar wrote:
> >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
> > > Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
> > > Submitter	: Kumar Gala <galak@kernel.crashing.org>
> > > Date		: 2009-04-09 15:43 (38 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
> > > References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
> > > 		  http://lkml.org/lkml/2009/4/10/193
> > > Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> >
> > Oleg says in that thread that it's as-designed, and followup
> > questions were not replied to (yet).
> 
> Yes, I think this is false alarm. Perhaps I missed something, and 
> I am waiting for more info from Kumar, but it looks like ltp was 
> already changed to skip the "{ PTRACE_ATTACH, 1, EPERM }" test on 
> kernels after 2.6.25

Btw., why did the patch (and the revert) make any difference to the 
test? Timing differences look improbable.

	Ingo
