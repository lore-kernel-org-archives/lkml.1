Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbZBSIjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbZBSIjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 03:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZBSIj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 03:39:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:57867 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZBSIj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 03:39:26 -0500
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Collins <paul@burly.ondioline.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <87r61uzv95.fsf@burly.wgtn.ondioline.org>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.p4D.L20jJB@chimera>
	 <878wognj00.fsf@burly.wgtn.ondioline.org> <200902142342.59186.rjw@sisk.pl>
	 <87hc2u26m5.fsf@burly.wgtn.ondioline.org>
	 <1234775410.26036.122.camel@pasglop>
	 <87d4di1wwr.fsf@burly.wgtn.ondioline.org>
	 <87r61uzv95.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 19:38:30 +1100
Message-Id: <1235032710.8805.37.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 21:27 +1300, Paul Collins wrote:
> > Just for laughs I slapped together the following, which seems to do
> the
> > job, although not especially tidily.
> 
> And it doesn't even do the job.  Judging by this new trace, submitting
> input events from the via-pmu resume function is still too early.
> 
What's up Thomas ? We can't call gettimeofday() from a sysdev
suspend/resume ? That's a little bit too harsh no ?

Cheers,
Ben.

