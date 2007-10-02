Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXJBObw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXJBObw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbXJBObp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:31:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbXJBObp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:31:45 -0400
Date: Tue, 2 Oct 2007 16:31:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002143115.GA4867@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <alpine.LRH.0.999.0710021250510.23586@www.tglx.de> <20071002140711.GA29395@elte.hu> <200710021623.09966.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710021623.09966.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Andi Kleen <ak@suse.de> wrote:

> > Andi, could you please send us the list of patches from the 
> > current.tar.gz queue above that you consider 2.6.24 candidates?
> 
> Everything in principle except the patches marked with TBD.

ok, the ones marked TBD are:

 cflags-probe
 cpa-clflush
 sched-clock-share
 svm-disabled
 unwinder

> > (and please add to the list if there's anything else pending)
> 
> I'm still merging/fixing etc. so the list is not final yet.

please merge it ontop of the arch/x86 tree so that we can start 
reviewing and testing it based on the unified tree ASAP. (but sending us 
a queue to the old layout is fine too - whichever variant you can do 
fastest) Thanks,

	Ingo
