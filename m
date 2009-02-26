Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZBZM06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZBZM06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZBZM0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:26:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZBZM0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:26:49 -0500
Date: Thu, 26 Feb 2009 13:26:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
Message-ID: <20090226122623.GC23099@elte.hu>
References: <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com> <49A65455.4030204@cn.fujitsu.com> <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com> <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com> <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com> <1235645076.4645.4781.camel@laptop> <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com> <1235647682.4948.15.camel@laptop> <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com> <1235650806.4948.71.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235650806.4948.71.camel@laptop>
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

> On Thu, 2009-02-26 at 21:06 +0900, KAMEZAWA Hiroyuki wrote:
> > Hmm.. some routine like
> > atomic64_read() can help this ? (But I don't want to use atomic_t here..)
> 
> Yeah, atomic64_t has been proposed numerous times, and x86 
> could actually implement that using cmpxchg8b, just not sure 
> about all the other 32bit archs, and if we start using it in 
> the scheduler, they'd better have it implemented.

I have written a working atomic64_t implementation for 
tip:perfcounters/core, for 32-bit x86.

	Ingo
