Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYIJMC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYIJMC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYIJMCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:02:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46715 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYIJMCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:02:47 -0400
Date: Wed, 10 Sep 2008 14:02:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Yang, Sheng" <sheng.yang@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW
	features
Message-ID: <20080910120231.GB4970@elte.hu>
References: <12209432941440-git-send-email-sheng.yang@intel.com> <86802c440809091045h2d4f1776g94355e1b1dd1b29e@mail.gmail.com> <20080910080421.GC15255@elte.hu> <200809101842.31355.sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101842.31355.sheng.yang@intel.com>
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


* Yang, Sheng <sheng.yang@intel.com> wrote:

> On Wednesday 10 September 2008 16:04:21 Ingo Molnar wrote:
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > On Tue, Sep 9, 2008 at 1:05 AM, Yang, Sheng <sheng.yang@intel.com> wrote:
> > > > Yeah, I've considered that, but seems duplicate for both files? The
> > > > feature detection code is the same. Any way to merge them?
> > >
> > > just merged intel_64.c into intel.c...
> >
> > it's all in tip/master:
> >
> >   http://people.redhat.com/mingo/tip.git/README
> >
> > would it be possible to get a patchset ontop of that?
> >
> > 	Ingo
> 
> So quick.... 

hey, wasting time is something we really suck at ;-)

> Thanks Yinghai!
> 
> Would send the updated patch soon.

got it, thanks. I've applied patch #1 and updated patch #2 to the 
tip/x86/unify-cpu-detect topic tree:

 e38e05a: x86: extended "flags" to show virtualization HW feature in /proc/cpuinfo
 315a655: x86: move VMX MSRs to msr-index.h

	Ingo
