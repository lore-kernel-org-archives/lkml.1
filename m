Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbXLBPp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbXLBPp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXLBPpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:45:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbXLBPpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:45:07 -0500
Date: Sun, 2 Dec 2007 16:44:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202154437.GA26261@elte.hu>
References: <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202123125.GA9516@lazybastard.org> <20071202144635.GC9516@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071202144635.GC9516@lazybastard.org>
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


* Jörn Engel <joern@logfs.org> wrote:

> On Sun, 2 December 2007 13:31:25 +0100, Jörn Engel wrote:
> > 
> > After another ten or so notrace annotations throughout the spinlock
> > code, the latency tracer appears to work.  Not sure how many useful
> > information is missing through all the annotations, though.
> 
> And here is a patch with the needed annotations.  Looks a bit shabby, 
> as it was generated though git diff, patcher, interdiff and 
> combinediff.

thanks - the patches applied fine, i've added them to my latency-tracer 
patchqueue. Steve Rostedt might want to pick the fixes up for -rt as 
well.

	Ingo
