Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZBZQNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZBZQNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbZBZQNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:13:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbZBZQNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:13:18 -0500
Date: Thu, 26 Feb 2009 17:12:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, ego@in.ibm.com, tglx@linutronix.de,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arun@linux.vnet.ibm.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090226161255.GA15390@elte.hu>
References: <20090220115745.43d202d6@infradead.org> <20090220215318.GA30665@elte.hu> <20090223075521.GA3725@balbir.in.ibm.com> <20090223091158.GJ9582@elte.hu> <20090223094850.GA10226@balbir.in.ibm.com> <20090223103814.GB8817@dirshya.in.ibm.com> <20090223110725.GB17312@elte.hu> <20090226085831.GA28397@in.ibm.com> <20090226154526.GD352@elte.hu> <1235664169.4948.319.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235664169.4948.319.camel@laptop>
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

> On Thu, 2009-02-26 at 16:45 +0100, Ingo Molnar wrote:
> 
> > Yes - but that kind of policy should be coupled and expressed 
> > via cpusets. /proc based irq_affinity is just a limited, 
> > inflexible hack. All things IRQ partitioning should be handled 
> > via cpusets - perhaps via the 'system sets' idea from Peter?
> 
> all we got out of that idea was the default_smp_affinity thing 
> in /proc/irq and a head-ache trying to work out silly details.
> 
> Maybe we ought to try again,..

Your system sets patch was actually very sane, it just fell 
victim to a merge window i think. Mind re-sending it?

	Ingo
