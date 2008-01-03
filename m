Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYACPsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYACPsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759182AbYACPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:44:20 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36190 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbYACPoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:44:18 -0500
Date: Thu, 3 Jan 2008 21:14:23 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, hskinnemoen@atmel.com, mhiramat@redhat.com,
       sam@ravnborg.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/2] Kprobes: Move kprobes examples to samples/
Message-ID: <20080103154423.GA5273@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080103062425.GA22781@in.ibm.com> <20080103062825.GB22781@in.ibm.com> <20080103093303.GB16803@elte.hu> <20080103102233.GB28934@in.ibm.com> <20080103110459.GI29194@elte.hu> <20080103151806.GA23967@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103151806.GA23967@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 10:18:06AM -0500, Mathieu Desnoyers wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > 
> > > > feature request: please make this work in the !modular case as well 
> > > > - if built-in then it should just run sometime during bootup and run 
> > > > the tests and report success/failure. This way automated testing can 
> > > > pick up any regressions much easier.
> > > 
> > > Will try cook up something along those lines. It'll be easy to verify 
> > > if the probes inserted and removed properly, but verifying handlers 
> > > run correctly will need some work.
> > > 
> > > We have a sort of regression test bucket that uses expect to parse the 
> > > dmesg to verify handlers did run correctly; that isn't a totally 
> > > in-kernel solution anyway. I have a couple of ideas in mind to make it 
> > > easier.
> > 
> > Great. Would be really nice to have something along the lines of 
> > CONFIG_DEBUG_LOCKING_API_SELFTESTS. Those unit tests took time to 
> > develop, but they caught more than 90% (!) of the internal lockdep 
> > engine bugs before they ever hit mainline.
> > 
> 
> I would just like to point out that the samples/ directory should keep
> files as easy to read and understand for newcomers (it is meant to be
> compiled Documentation examples). I see the interest in turning it into
> a regression test too, but I would recommend leaving the "test" code out
> of the sample module itself to improve readability.

Agreed. I am working on a test bucket that doesn't touch the samples.
It'll live on its own, helping with boot time smoke tests.

Ananth
