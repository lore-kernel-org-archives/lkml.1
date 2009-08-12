Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbZHLJDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbZHLJDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZHLJDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:03:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZHLJDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:03:14 -0400
Date: Wed, 12 Aug 2009 11:02:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
Message-ID: <20090812090234.GB14114@elte.hu>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com> <1250006744.10001.29.camel@twins> <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com> <1250024143.7091.7.camel@laptop> <7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com> <1250065963.10001.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250065963.10001.30.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-08-11 at 23:08 +0200, stephane eranian wrote:
> 
> > But aren't you going to change the cpu, pid target stuff we 
> > discussed a couple of weeks ago anyway?
> 
> Right, I'd like to, but Ingo doesn't. I haven't heard back from 
> Paul on this.

Not sure we want to change it. Mixing PID and CPU into the same 
space disallows the simultaneous application of both. I.e. right now 
we allow 3 models:

 - PID-ish
 - CPU-ish
 - PID and CPU [say measure CPU#2 component of an inherited workload.]

Also, i dont really see the use-cases for new targets. (i've seen a 
few mentioned but none seemed valid) What new targets do people have 
in mind?

	Ingo
