Return-Path: <linux-kernel-owner+w=401wt.eu-S1422651AbXCWHPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651AbXCWHPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422657AbXCWHPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:15:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934016AbXCWHPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:15:12 -0400
Date: Fri, 23 Mar 2007 08:15:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-rt0-kdump (was: Re: [patch] setup_boot_APIC_clock() irq-enable fix)
Message-ID: <20070323071502.GA2090@elte.hu>
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com> <20070322093119.GA19394@elte.hu> <6bffcb0e0703220557h7ff64282qf378623452c07d03@mail.gmail.com> <4602843D.9000306@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4602843D.9000306@googlemail.com>
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


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> >> > BUG: at kernel/fork.c:1033 copy_process()
> >>
> >> thanks Michal - this is a real bug that affects upstream too. Find 
> >> the fix below - i've test-booted it and it fixes the warning.
> > 
> > Problem is fixed, thanks.
> 
> BTW. It seems that nobody uses -rt as a crash dump kernel ;)

it's been tested with v2.6.20-rt8, and it should work as long as you 
enable CONFIG_RELOCATABLE. But i'm not using it myself, and 
v2.6.21-rc4-rt0 isnt a particularly encouraging version string for 
people to try ;)

> Hibernation is still broken.
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/console.log
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/rt-config

what's the failure mode besides the lockdep + other debug messages - it 
doesnt resume? Your log seems to have at least one sequence of resume 
related messages - those seem to have worked fine.

	Ingo
