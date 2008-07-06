Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYGFOPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYGFOPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYGFOOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:14:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbYGFOOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:14:53 -0400
Date: Sun, 6 Jul 2008 16:14:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706141416.GB20940@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
> Subject		: x86-64 NODES_SHIFT compile failure.
> Submitter	: Dave Jones <davej@codemonkey.org.uk>
> Date		: 2008-05-16 12:54 (52 days old)
> References	: http://lkml.org/lkml/2008/5/16/312
> Handled-By	: Mike Travis <travis@sgi.com>
> Patch		: http://lkml.org/lkml/2008/5/16/343

fixed by:

 commit efac41894df57d32b483ac622d03541b5b2692c0
 Author: Thomas Gleixner <tglx@linutronix.de>
 Date:   Tue Jul 1 08:56:32 2008 +0200

     x86: fix NODES_SHIFT Kconfig range

	Ingo
