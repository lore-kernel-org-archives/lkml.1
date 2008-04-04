Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYDDOrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYDDOrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYDDOq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:46:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679AbYDDOq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:46:57 -0400
Date: Fri, 4 Apr 2008 16:46:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@ozlabs.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Arnd Bergmann <arndb@de.ibm.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: cpu_clock confusion (was: printk time confusion?)
Message-ID: <20080404144641.GA15844@elte.hu>
References: <1207146186.3957.11.camel@johannes.berg> <1207219724.10388.319.camel@pasglop> <1207240450.3797.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207240450.3797.22.camel@johannes.berg>
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> Hi,
> 
> > > Not sure whether the lockdep patches or something else is causing this
> > > as I haven't checked w/o the patches yet, but I seem to be having some
> > > confusion of printk timestamps:
> > 
> > Tried reverting the patches ?
> 
> That didn't help, so it's not the lockdep patches causing it. I'm still
> seeing printk timestamps like this:
> 
> [    2.764009 (3/3)]
> [    4.272241 (2/2)]
> [    4.272322 (2/2)]
> [    4.272375 (2/2)]
> [    2.948002 (3/3)]
> 
> As you can see, I added printk_cpu and smp_processor_id() to the 
> printk timestamp output and thus it is obvious that the different 
> times come from different CPUs.

the fixes are queued for v2.6.26. You can pick them up from 
sched-devel/latest as well:

  http://people.redhat.com/mingo/sched-devel.git/README

	Ingo
