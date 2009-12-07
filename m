Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZLGHHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZLGHHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZLGHHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:07:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37057 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbZLGHHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:07:20 -0500
Date: Mon, 7 Dec 2009 08:07:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] perf: Make location of kernel source configurable
Message-ID: <20091207070715.GC10868@elte.hu>
References: <20091206307.542816612@firstfloor.org>
 <20091207061839.GB5186@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207061839.GB5186@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sun, Dec 06, 2009 at 03:07:30PM +0100, Andi Kleen wrote:
> > 
> > tools/perf has no support for separate object directories
> > and lots of hard coded paths assuming that the kernel source
> > is always in ../..
> > 
> > As a first step of compiling it separately without messing
> > up clean source trees allow to configure the kernel source
> > location using a KERNELSRC variable 
> > 
> > This allows at least to copy the whole tools/perf
> > directory elsewhere and build it separately.
> > 
> > The default is still ../.., so for a standard build
> > nothing changes
> > 
> > This also removes a lot of ugly ../.. from the source.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> 
> It does not apply cleanly, it seems you are using 2.6.32 There have a 
> been a lot of updates in this merge window.
> 
> Could you please resend against latest linus tree?

Even better would be a patch against latest -tip:

  http://people.redhat.com/mingo/tip.git/README

which includes the latest perf event tree.

Thanks,

	Ingo
