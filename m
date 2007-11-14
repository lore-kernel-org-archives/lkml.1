Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbXKNUzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbXKNUzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbXKNUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:55:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbXKNUy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:54:59 -0500
Date: Wed, 14 Nov 2007 21:54:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>, rdunlap@xenotime.net,
       akpm@linux-foundation.org, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071114205427.GC20606@elte.hu>
References: <20071113134029.GA30978@elte.hu> <20071113085514.3414aa52.rdunlap@xenotime.net> <20071114140847.GA11489@elte.hu> <20071114.115601.00715073.davem@davemloft.net> <1195070954.8364.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195070954.8364.41.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2007-11-14 at 11:56 -0800, David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Wed, 14 Nov 2007 15:08:47 +0100
> > 
> > > In fact this thread is the very example: David points out that on netdev 
> > > some of those bugs were already discussed and resolved. Had it been all 
> > > on lkml we'd all be aware of it.
> > 
> > That's a rediculious argument.
> > 
> > One other reason these bugs are resolved, is that the networking 
> > developers only need to subscribe to netdev and not have to listen 
> > to all the noise on lkml.
> > 
> > People who want to manage bugs know what list to look on and contact 
> > about problems.
> > 
> > Dumping even more crap on lkml is not the answer.
> 
> I agree totally with David, and this goes for SCSI too.  If it's not 
> reported on linux-scsi, there's a significant chance of us missing the 
> bug report.  The fact that some people notice bugs go past on LKML and 
> forward them to linux-scsi is a happy accident and not necessarily 
> something to rely on.
> 
> LKML has 10-20x the traffic of linux-scsi and a much smaller signal to 
> noise ratio.  Having a specialist list where all the experts in the 
> field hangs out actually enhances our ability to fix bugs.

you are actually proving my point. People have to scan lkml for SCSI 
regressions _anyway_, because otherwise _you_ would miss them. In the 
case a user is fortunate enough to realize that a regression is SCSI 
related, and he is lucky enough to pre-select the SCSI mailing list in 
the first go, he might get a fix from you. That already reduces the 
number of useful bugreports by about an order of magnitude.

	Ingo
