Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKYQef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKYQef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYKYQeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:34:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbYKYQeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:34:13 -0500
Date: Tue, 25 Nov 2008 17:33:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Message-ID: <20081125163350.GC22504@elte.hu>
References: <20081125092415.A31432@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125092415.A31432@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> A prototype for a BTS ftrace plug-in.
> 
> The tracer collects branch trace in a cyclic buffer for each cpu.
> 
> The tracer is not configurable and the trace for each snapshot is 
> appended when doing cat /debug/tracing/trace.
> 
> This is a proof of concept that will be extended with future patches 
> to become a (hopefully) useful tool.
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

very nice stuff!

i've created a new topic branch for this: 

   tip/tracing/hw-branch-tracing

and applied your patches there. (applied the earlier x86 patches in 
their appropriate x86 topic branches)

Integrated the end result into tip/master and have started testing it.

I've got a few more review comments as well - will post them as a 
reply to the respective patches.

	Ingo
