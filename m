Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZLDLMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZLDLMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZLDLMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:12:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:54227 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbZLDLMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:12:21 -0500
Subject: Re: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259924920.17907.8.camel@laptop>
References: <4B18D66E.8020905@suse.de> <20091204095408.GA26118@elte.hu>
	 <4B18E257.2080009@suse.de>  <1259924920.17907.8.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 12:12:22 +0100
Message-ID: <1259925142.17907.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 12:08 +0100, Peter Zijlstra wrote:
> On Fri, 2009-12-04 at 15:50 +0530, Suresh Jayaraman wrote:
> > 
> > I think originally introduced as a development/debugging facility,
> > sched_features is slowly transforming into a viable tool for System
> > Administrators, by looking at the impact of turning on/off some of these
> > features on some workloads (especially non-desktop workloads). And I
> > think these benefits should be passed on to the end users perhaps in the
> > form of documentation. 
> 
> This is really not meant to be used in that context. Its purely a debug
> feature, with knobs coming and going as we see fit.

That is, if this is how people are using it, I'll actually consider
removing the whole interface and keep it as an out-of-tree debug patch.

If a workload isn't working with the defaults they need to report a bug,
after that we can ask them to twiddle with some knobs to see what it is
that is not working.



