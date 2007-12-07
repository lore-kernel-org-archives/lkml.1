Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbXLGJdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbXLGJdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXLGJdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:33:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbXLGJdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:33:36 -0500
Date: Fri, 7 Dec 2007 10:33:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Tracy <rct@frus.com>, mcree@orcon.net.nz, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Message-ID: <20071207093304.GC21135@elte.hu>
References: <20071204121618.GA26132@elte.hu> <20071207001612.39E36DBA2@gherkin.frus.com> <20071206163305.c3587675.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206163305.c3587675.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > # bad: [6f37ac793d6ba7b35d338f791974166f67fdd9ba] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> > git-bisect bad 6f37ac793d6ba7b35d338f791974166f67fdd9ba
> > # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> > git-bisect good 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3

> I'm struggling to see how any of those could have broken block device 
> mounting on alpha.  Are you sure you bisected right?

the bisection log looks healthy so far - with nicely alternating 
good/bad bisection points. Barring the possibility that the bug is 
non-deterministic, i'd guess the bisection points are OK, at least 
judging from their statistical properties.

but ... i went over the diffs too, and i fail to see how they could 
affect the bootup path of an Alpha box, which i suspect has no 
networking dependency up to the failure point.

	Ingo
