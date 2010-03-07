Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0CGSnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 13:43:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59093 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab0CGSnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 13:43:46 -0500
Date: Sun, 7 Mar 2010 19:42:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Avi Kivity <avi@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>, ming.m.lin@intel.com,
       sheng.yang@intel.com, Jes Sorensen <Jes.Sorensen@redhat.com>,
       KVM General <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: KVM usability
Message-ID: <20100307184258.GA31061@elte.hu>
References: <20100227105643.GA17425@elte.hu>
 <4B893B2B.40301@redhat.com>
 <20100227172546.GA31472@elte.hu>
 <4B8BEFC7.2040000@redhat.com>
 <20100301174106.GB2362@ghostprotocols.net>
 <4B8C0778.8050908@redhat.com>
 <20100301205620.GA26151@elte.hu>
 <20100302103045.GA28310@elte.hu>
 <4B937363.4070406@redhat.com>
 <84144f021003070156p2e0e86fche27c2b8d7d3e760@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021003070156p2e0e86fche27c2b8d7d3e760@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> That said, AFAICT, it should be pretty simple to implement a shark-like UI 
> with GTK as current perf code is pretty good fit for that. I've pondered 
> about doing that myself but quite frankly, I don't see any big gains in 
> that.

There's a perf events based GUI: sysprof.

It's not integrated into tools/perf/ (it's using the syscall) and we'd welcome 
it integrated as 'perf view' or 'perf gui' - just like we'd welcome a new 
from-scratch GUI frontend as well.

The latter would have the advantage of growing gradually and naturally - so if 
you feel like implementing it, please do not hesitate ;-) I had a good hard 
look at the perf GUI situation a few months ago and GTK looks like the best 
fit.

Even if it's simple initially it would clearly show us the exact demand of GUI 
versus TUI. I.e. if you are right and it doesnt matter, it will stay simple, 
if Avi is right and it matters then people will use it as a base and improve 
it. A win-win scenario.

Thanks,

	Ingo
