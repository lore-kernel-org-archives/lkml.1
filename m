Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbXBWLpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbXBWLpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXBWLpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:45:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56766 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbXBWLpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:45:04 -0500
Date: Fri, 23 Feb 2007 12:39:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, dwalker@mvista.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21-rc1
Message-ID: <20070223113957.GA3111@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <1172075053.8577.38.camel@imap.mvista.com> <1172077664.25076.75.camel@localhost.localdomain> <1172078340.8577.43.camel@imap.mvista.com> <1172079671.25076.80.camel@localhost.localdomain> <20070223020829.40e5fac3.akpm@linux-foundation.org> <20070223113500.GB1177@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223113500.GB1177@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0559]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I already bisected this on my old pIII, which has the same problem: 
> > clockevents-i386-drivers.patch
> 
> yes - we know what the problem is (and will fix it): the stopping of the 
> PIT - nmi_watchdog=1 is hack to use the IO-APIC's PIT pin to also signal 
> NMIs.
> 
> Just to clarify, this problem does not occur if HIGH_RES_TIMERS is 
> off, correct?

s/does not occur/does occur/

we switch off the PIT whenever we can.

	Ingo
