Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZD1IxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZD1IxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZD1IxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:53:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZD1IxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:53:11 -0400
Date: Tue, 28 Apr 2009 10:52:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: svaidy@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
	sched_mc=n
Message-ID: <20090428085237.GB26487@elte.hu>
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com> <1240826954.8216.8.camel@twins> <20090427142044.GA7178@dirshya.in.ibm.com> <1240907618.7620.86.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240907618.7620.86.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > Also, the user interface should be that single thermal 
> > > capacity knob, more fine grained control is undesired.
> > 
> > For power savings, a single evacuation knob will do.  While for 
> > thermal we will need additional parameters to choose the right 
> > cores to evacuate.  Some sort of directional/vector parameter.
> 
> Why? are machines that non-uniform in cooling capacity that it 
> really matters which core generates the heat? Sounds like badly 
> designed hardware to me.
> 
> I would expect it to only be the total head generated/power taken 
> from the rack unit.

If we add thermal throttling at the kernel level then a single knob 
(with a percentile-ish unit) is probably the furthest we will go - 
with "not doing it at all" still being the other, very tempting 
alternative.

If the only technical way you can find to do it is via myriads of 
non-intuitive knobs and per core settings - then the answer is 
really 'no thanks'.

	Ingo
