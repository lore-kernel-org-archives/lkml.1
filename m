Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYCYQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYCYQvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbYCYQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:51:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758687AbYCYQvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:51:10 -0400
Date: Tue, 25 Mar 2008 17:50:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
Message-ID: <20080325165007.GA7775@elte.hu>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325073117.GA8469@elte.hu>
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

> 64-bit ioremaps never worked on 32-bit, so we are in totally 
> unchartered waters now - but due to the unification we have a 
> realistic chance to make them work. At minimum we need the fix below 
> in addition to Linus' patch - does it make any difference?

could you please try x86.git/latest:

  http://people.redhat.com/mingo/x86.git/README

which has all the fixes and debug patches integrated (no extra patching 
should be needed). If it still doesnt work then please send the new 
dmesg and /sys/kernel/debug/kernel_page_tables dump.

head 0fef904c33841be92f or later.

	Ingo
