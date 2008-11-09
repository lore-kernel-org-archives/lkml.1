Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYKIVi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYKIVi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYKIViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:38:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475AbYKIViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:38:04 -0500
Date: Sun, 9 Nov 2008 22:37:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-ID: <20081109213738.GA20267@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <20081107093911.GD7787@elte.hu> <20081107122400.GA20777@elte.hu> <200811082024.20157.rusty@rustcorp.com.au> <alpine.LFD.2.00.0811091200090.3468@nehalem.linux-foundation.org> <20081109201600.GA22208@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109201600.GA22208@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > On Sat, 8 Nov 2008, Rusty Russell wrote:
> > > 
> > > Ok, I sent through the latest delta on top of this before, but see below.
> > 
> > Can somebody send a final patch-set to me? Right now I have multiple 
> > versions of patches, apparently on top of each other, and sometimes 
> > multiple patches per email. Very confusing, and I do _not_ want to 
> > apply the wrong thing by mistake.
> 
> I've got them collected and tested (and so has Rusty), see the tree 
> URI below. There's no pending problem left that i know of. I also 
> just did a fresh test-build and test-boot of this tree, for good 
> measure.

Thomas did a cross-build test of Linus's latest 
(v2.6.28-rc3-261-g8b805ef), and it seems OK (see the results below) - 
no new cross-build failures introduced.

	Ingo

--------------->
Run 142: 2008-11-09 21:38:04 .. 2008-11-09 22:30:35

Run 142: 17 of 19 operations OK
Run 142: 2 of 19 operations FAILED

http://www.tglx.de/autoqa-logs/000142-0008-0005.log
http://www.tglx.de/autoqa-logs/000142-0008-0015.log

Changed warnings:
http://www.tglx.de/autoqa-logs/d000141-000142-0008-0006.log
http://www.tglx.de/autoqa-logs/d000141-000142-0008-0023.log
http://www.tglx.de/autoqa-logs/d000141-000142-0008-0024.log

Full results at: http://www.tglx.de/autoqa/index
_______________________________________________
autoqa mailing list
autoqa@www.tglx.de
http://www.tglx.de/mailman/listinfo/autoqa
