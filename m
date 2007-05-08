Return-Path: <linux-kernel-owner+w=401wt.eu-S967342AbXEHPYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967342AbXEHPYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXEHPKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:10:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934572AbXEHPFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:05:25 -0400
Date: Tue, 8 May 2007 17:04:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: [patch] CFS scheduler, -v11
Message-ID: <20070508150431.GA26977@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> [...] Values 0x3 and 0xb are merely context switch happy.

thanks Mike - value 0x8 looks pretty good here and doesnt have the 
artifacts you found. I've done a quick -v11 release with that fixed, 
available at the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

with no other changes.

	Ingo
